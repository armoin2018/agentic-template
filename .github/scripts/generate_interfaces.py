

#!/usr/bin/env python3
"""
Generate interface-specific branches from a single canonical source of files.

Usage (from repo root or via GitHub Actions step):
    python .github/scripts/generate_interfaces.py map.yaml

Behavior:
- Reads a YAML manifest describing interface targets and copy mappings.
- For each target, materializes files into a dedicated worktree checked out
  to branch `template-<target>`.
- Performs token replacement for placeholders like {{TOKEN}} using
  `template_vars` (global) and per-target overrides.
- Commits results to the target branch (creating it if needed).

Manifest shape (example):

```yaml
template_vars:               # optional global tokens
  ORG: "Acme"
  OWNER_EMAIL: "dev@acme.com"
exclude:                     # optional global exclude globs
  - "**/.git/**"
  - "**/.DS_Store"
  - "**/*.md.keep"

targets:
  claude:
    template_vars:           # optional per-target tokens (override globals)
      ASSISTANT: "Claude"
    exclude:                 # optional per-target exclude globs
      - "**/.github/**"
    copies:                  # required list of copy mappings
      - from: shared/prompts/base_prompt.md   # file or directory
        to: .claude/prompts/BASE.md           # destination file/dir
      - from: shared/claude/commands/
        to: .claude/commands/
  copilot:
    copies:
      - from: shared/prompts/base_prompt.md
        to: .copilot/skillsets/base-prompt.md
      - from: shared/copilot/skillsets/
        to: .copilot/skillsets/
```

Notes:
- If `to` ends with a path separator or the source is a directory, the copy is recursive into that directory.
- Binary files are copied byte-for-byte; text files (UTF-8) receive token substitution.
- Existing contents of the target branch worktree (except .git) are deleted before copying.
- Requires: PyYAML (install with `pip install pyyaml`).
"""

from __future__ import annotations

import fnmatch
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Dict, Iterable, List, Tuple

try:
    import yaml
except Exception as e:
    print("[ERROR] PyYAML is required. Install with: pip install pyyaml", file=sys.stderr)
    raise

RE_TOKEN = re.compile(r"\{\{([A-Z0-9_]+)\}\}")
TEXT_EXT_HINT = {
    ".txt", ".md", ".markdown", ".json", ".yaml", ".yml", ".xml",
    ".toml", ".ini", ".cfg", ".conf", ".py", ".js", ".ts", ".tsx",
    ".jsx", ".cjs", ".mjs", ".css", ".scss", ".sass", ".html", ".htm",
    ".sh", ".bash", ".zsh", ".ps1", ".Dockerfile", ".env", ".gitignore",
    ".gitattributes", ".editorconfig",
}

# --- helpers ---------------------------------------------------------------

def run(cmd: List[str], cwd: Path | None = None, check: bool = True) -> subprocess.CompletedProcess:
    """Run a shell command and stream output."""
    print(f"[CMD] {' '.join(cmd)} (cwd={cwd or Path.cwd()})")
    cp = subprocess.run(cmd, cwd=cwd, check=False, text=True)
    if check and cp.returncode != 0:
        raise subprocess.CalledProcessError(cp.returncode, cmd)
    return cp


def repo_root_from_script() -> Path:
    # .github/scripts/generate_interfaces.py -> repo root is two levels up
    here = Path(__file__).resolve()
    root = here.parents[2]
    return root


def load_manifest(manifest_path: Path) -> dict:
    with open(manifest_path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f) or {}
    if "targets" not in data or not isinstance(data["targets"], dict):
        raise ValueError("Manifest must contain a 'targets' mapping.")
    return data


def is_text_file(path: Path) -> bool:
    # Heuristic: use extension hint OR try to decode as UTF-8 small sample
    if path.suffix in TEXT_EXT_HINT:
        return True
    try:
        with open(path, "rb") as f:
            sample = f.read(8192)
        sample.decode("utf-8")
        return True
    except Exception:
        return False


def should_exclude(rel_path: str, patterns: Iterable[str]) -> bool:
    return any(fnmatch.fnmatch(rel_path, pat) for pat in patterns)


def render_text(content: str, tokens: Dict[str, str]) -> str:
    def _repl(m: re.Match) -> str:
        key = m.group(1)
        return tokens.get(key, m.group(0))
    return RE_TOKEN.sub(_repl, content)


def ensure_clean_dir(dir_path: Path):
    dir_path.mkdir(parents=True, exist_ok=True)
    for item in dir_path.iterdir():
        if item.name == ".git":
            continue
        if item.is_dir():
            shutil.rmtree(item)
        else:
            item.unlink()


def copy_entry(src: Path, dst: Path, tokens: Dict[str, str], excludes: List[str], base_src: Path):
    """Copy file or directory from src to dst. Perform token replacement on text files.
    `dst` is treated as a file if src is file; if src is dir, copy recursively under dst.
    `excludes` are evaluated against source-relative paths (posix style).
    """
    if not src.exists():
        raise FileNotFoundError(f"Source path does not exist: {src}")

    def _copy_file(s: Path, d: Path, rel: str):
        # Skip excluded
        rel_posix = rel.replace(os.sep, "/")
        if should_exclude(rel_posix, excludes):
            return
        d.parent.mkdir(parents=True, exist_ok=True)
        if is_text_file(s):
            try:
                text = s.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                # Fallback to binary copy
                shutil.copy2(s, d)
                return
            rendered = render_text(text, tokens)
            d.write_text(rendered, encoding="utf-8")
        else:
            shutil.copy2(s, d)

    if src.is_dir():
        for root, _, files in os.walk(src):
            root_p = Path(root)
            for name in files:
                s = root_p / name
                rel = s.relative_to(base_src).as_posix() if s.is_relative_to(base_src) else s.name
                # Determine destination path under dst directory
                rel_under_src = s.relative_to(src)
                d = dst / rel_under_src
                _copy_file(s, d, rel)
    else:
        # Determine if dst is explicitly a directory (ends with slash-like intent)
        if dst.exists() and dst.is_dir():
            d = dst / src.name
        else:
            # If parent has trailing slash intent, caller should have provided directory
            d = dst
        rel = src.relative_to(base_src).as_posix() if src.is_relative_to(base_src) else src.name
        _copy_file(src, d, rel)


def build_target_tree(repo_root: Path, target_name: str, target_cfg: dict, global_tokens: Dict[str, str], global_excludes: List[str]) -> Path:
    """Create a temporary directory with the fully materialized target tree."""
    tmp_dir = Path(tempfile.mkdtemp(prefix=f"iface_{target_name}_"))
    tokens = dict(global_tokens)
    tokens.update(target_cfg.get("template_vars", {}) or {})
    excludes = list(global_excludes)
    excludes.extend(target_cfg.get("exclude", []) or [])

    copies = target_cfg.get("copies")
    if not copies:
        raise ValueError(f"Target '{target_name}' has no 'copies' entries.")

    for entry in copies:
        src_rel = entry.get("from")
        dst_rel = entry.get("to")
        if not src_rel or not dst_rel:
            raise ValueError(f"Invalid copy entry in '{target_name}': {entry}")
        src = (repo_root / src_rel).resolve()
        # If dst looks like a directory (ends with '/' in YAML) ensure directory semantics
        dst = (tmp_dir / dst_rel).resolve()
        base_src = src if src.is_dir() else src.parent
        copy_entry(src, dst, tokens, excludes, base_src)

    return tmp_dir


def ensure_worktree(repo_root: Path, branch: str) -> Path:
    """Create or re-use a git worktree for a branch under ./.interface_build/<branch>."""
    build_root = repo_root / ".interface_build"
    worktree_dir = build_root / branch
    build_root.mkdir(exist_ok=True)

    # If worktree exists, remove and recreate to avoid stale state
    if worktree_dir.exists():
        # Attempt to prune any existing worktree association
        try:
            run(["git", "worktree", "remove", "--force", str(worktree_dir)], cwd=repo_root, check=False)
        except Exception:
            pass
        shutil.rmtree(worktree_dir, ignore_errors=True)

    # Create/attach worktree for branch; if branch doesn't exist, create it
    # `-B` creates or resets the branch to current HEAD (we will wipe files anyway)
    run(["git", "worktree", "add", "-B", branch, str(worktree_dir)], cwd=repo_root)

    # Clean everything except .git
    ensure_clean_dir(worktree_dir)
    return worktree_dir


def commit_target_branch(worktree_dir: Path, branch: str):
    # Git add & commit (ignore if no changes)
    run(["git", "add", "-A"], cwd=worktree_dir)
    # Check if there is anything to commit
    status = subprocess.run(["git", "status", "--porcelain"], cwd=worktree_dir, text=True, capture_output=True)
    if status.returncode != 0:
        raise subprocess.CalledProcessError(status.returncode, ["git", "status", "--porcelain"], status.stdout)
    if status.stdout.strip():
        run(["git", "commit", "-m", f"chore: generate {branch}"], cwd=worktree_dir)
    else:
        print(f"[INFO] No changes to commit for {branch}.")


def main(argv: List[str]) -> int:
    if len(argv) < 2:
        print("Usage: python .github/scripts/generate_interfaces.py map.yaml", file=sys.stderr)
        return 2

    manifest_path = Path(argv[1]).resolve()
    repo_root = repo_root_from_script()
    os.chdir(repo_root)
    print(f"[INFO] Repo root: {repo_root}")

    data = load_manifest(manifest_path)
    global_tokens = data.get("template_vars", {}) or {}
    global_excludes = data.get("exclude", []) or []

    targets = data["targets"]

    for target_name, target_cfg in targets.items():
        branch = f"template-{target_name}"
        print(f"\n[INFO] Building target '{target_name}' -> branch '{branch}'")
        out_tree = build_target_tree(repo_root, target_name, target_cfg, global_tokens, global_excludes)
        worktree_dir = ensure_worktree(repo_root, branch)

        # Copy generated tree into worktree
        for root, dirs, files in os.walk(out_tree):
            rel_root = Path(root).relative_to(out_tree)
            dest_root = worktree_dir / rel_root
            dest_root.mkdir(parents=True, exist_ok=True)
            for d in dirs:
                (dest_root / d).mkdir(parents=True, exist_ok=True)
            for f in files:
                src_file = Path(root) / f
                dst_file = dest_root / f
                shutil.copy2(src_file, dst_file)

        # Commit changes on the target branch
        commit_target_branch(worktree_dir, branch)

        # Detach worktree stays for subsequent push by the workflow step
        print(f"[INFO] Generated and committed {branch} at {worktree_dir}")

    print("\n[OK] All targets generated.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))