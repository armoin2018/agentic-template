````instructions
# Git Version Control Instructions

## Tool Overview
- **Tool Name**: Git
- **Version**: 2.40+ (stable), 2.45+ (latest with enhanced features)
- **Category**: Development Tools
- **Purpose**: Distributed version control system for tracking changes in source code
- **Prerequisites**: None (standalone tool), command line interface

## Installation & Setup
### Package Manager Installation
```bash
# macOS (Homebrew)
brew install git

# Ubuntu/Debian
sudo apt update && sudo apt install git

# CentOS/RHEL/Fedora
sudo yum install git
# or
sudo dnf install git

# Windows (Chocolatey)
choco install git

# Windows (Scoop)
scoop install git

# Verify installation
git --version
```

### Global Configuration
```bash
# Set up user identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Set default editor
git config --global core.editor "code --wait"  # VS Code
git config --global core.editor "vim"          # Vim
git config --global core.editor "nano"         # Nano

# Configure line endings
git config --global core.autocrlf false        # Unix/Mac
git config --global core.autocrlf true         # Windows

# Enable colored output
git config --global color.ui auto

# Set default merge strategy
git config --global pull.rebase false
```

### Project Initialization
```bash
# Initialize new repository
git init
git init project-name

# Clone existing repository
git clone https://github.com/user/repo.git
git clone git@github.com:user/repo.git  # SSH
git clone https://github.com/user/repo.git my-folder

# Set up remote origin
git remote add origin https://github.com/user/repo.git
git remote set-url origin git@github.com:user/repo.git

# Verify configuration
git config --list
git remote -v
```

## Core Features

### Basic Workflow Commands
- **Purpose**: Daily Git operations for version control
- **Usage**: Stage, commit, and synchronize changes
- **Example**:

```bash
# Check repository status
git status
git status --short
git status --porcelain

# Stage changes
git add file.txt                    # Stage specific file
git add .                          # Stage all changes
git add *.js                       # Stage by pattern
git add -A                         # Stage all including deleted
git add -u                         # Stage tracked files only
git add -p                         # Interactive staging

# Commit changes
git commit -m "Add new feature"
git commit -am "Fix bug"           # Stage and commit tracked files
git commit --amend                 # Amend last commit
git commit --amend --no-edit       # Amend without changing message

# View history
git log
git log --oneline
git log --graph --pretty=format:'%h %d %s (%cr) <%an>'
git log --stat
git log -p                         # Show diff
git log --since="2 weeks ago"
git log --author="John Doe"
```

### Branching and Merging
- **Purpose**: Manage parallel development and integrate changes
- **Usage**: Create, switch, and merge branches
- **Example**:

```bash
# Branch operations
git branch                         # List branches
git branch feature-name           # Create branch
git branch -d branch-name         # Delete branch
git branch -D branch-name         # Force delete
git branch -m old-name new-name   # Rename branch

# Switching branches
git checkout branch-name          # Switch to branch
git checkout -b feature-name      # Create and switch
git switch branch-name           # Modern syntax
git switch -c feature-name       # Create and switch

# Merging
git merge feature-branch         # Merge into current branch
git merge --no-ff feature-branch # Force merge commit
git merge --squash feature-branch # Squash merge

# Rebasing
git rebase main                  # Rebase current branch onto main
git rebase -i HEAD~3            # Interactive rebase last 3 commits
git rebase --continue           # Continue after resolving conflicts
git rebase --abort             # Abort rebase
```

### Remote Operations
- **Purpose**: Synchronize with remote repositories
- **Usage**: Push, pull, and fetch changes
- **Example**:

```bash
# Fetching and pulling
git fetch                        # Fetch all remotes
git fetch origin                # Fetch specific remote
git pull                        # Fetch and merge
git pull --rebase              # Fetch and rebase
git pull origin main           # Pull specific branch

# Pushing
git push                        # Push current branch
git push origin main           # Push to specific branch
git push -u origin feature     # Set upstream and push
git push --force-with-lease    # Safer force push
git push --tags               # Push tags

# Remote management
git remote -v                  # List remotes
git remote add upstream https://github.com/original/repo.git
git remote remove origin
git remote rename origin upstream
```

## Advanced Features

### Stashing Changes
- **Purpose**: Temporarily save uncommitted changes
- **Usage**: Switch contexts without committing incomplete work
- **Example**:

```bash
# Basic stashing
git stash                       # Stash current changes
git stash push -m "work in progress"  # Stash with message
git stash pop                   # Apply and remove last stash
git stash apply                 # Apply stash without removing

# Stash management
git stash list                  # List all stashes
git stash show stash@{0}       # Show stash diff
git stash drop stash@{0}       # Delete specific stash
git stash clear                # Delete all stashes

# Advanced stashing
git stash push -u              # Include untracked files
git stash push --keep-index    # Stash but keep staged changes
git stash push path/to/file    # Stash specific files
```

### Cherry-picking and Reverting
- **Purpose**: Apply or undo specific commits
- **Usage**: Selective commit application and rollback
- **Example**:

```bash
# Cherry-picking
git cherry-pick commit-hash    # Apply specific commit
git cherry-pick -n commit-hash # Cherry-pick without committing
git cherry-pick -x commit-hash # Include source commit reference
git cherry-pick start..end    # Cherry-pick range

# Reverting
git revert commit-hash         # Create revert commit
git revert -n commit-hash      # Revert without committing
git revert --strategy resolve commit-hash
git revert HEAD~3..HEAD       # Revert multiple commits

# Reset operations
git reset --soft HEAD~1       # Undo commit, keep changes staged
git reset --mixed HEAD~1      # Undo commit and staging
git reset --hard HEAD~1       # Undo commit and discard changes
git reset HEAD file.txt       # Unstage specific file
```

### Conflict Resolution
- **Purpose**: Resolve merge conflicts when branches diverge
- **Usage**: Handle conflicting changes during merges
- **Example**:

```bash
# During merge conflicts
git status                     # Check conflict status
git diff                      # View conflicts
git add resolved-file.txt     # Mark conflict as resolved
git commit                    # Complete merge

# Merge tools
git mergetool                 # Launch configured merge tool
git config --global merge.tool vimdiff
git config --global merge.tool vscode

# Conflict markers in files:
<<<<<<< HEAD
Current branch content
=======
Incoming branch content
>>>>>>> feature-branch

# Aborting merges
git merge --abort             # Cancel merge
git rebase --abort           # Cancel rebase
```

## Branch Management Strategies

### Git Flow
```bash
# Main branches
git checkout -b develop        # Development branch
git checkout -b release/1.0    # Release branch
git checkout -b hotfix/urgent  # Hotfix branch

# Feature development
git checkout develop
git checkout -b feature/user-auth
# Work on feature
git checkout develop
git merge feature/user-auth
git branch -d feature/user-auth

# Release process
git checkout -b release/1.0 develop
# Bug fixes for release
git checkout main
git merge release/1.0
git tag -a v1.0 -m "Version 1.0"
git checkout develop
git merge release/1.0
```

### GitHub Flow
```bash
# Simple branching model
git checkout main
git pull origin main
git checkout -b feature/new-feature

# Work and commit
git add .
git commit -m "Add new feature"
git push -u origin feature/new-feature

# Create pull request through GitHub UI
# After review and merge, cleanup
git checkout main
git pull origin main
git branch -d feature/new-feature
```

### GitLab Flow
```bash
# Environment branches
git checkout -b staging main
git checkout -b production main

# Feature development
git checkout main
git checkout -b feature/improvement
# Work and merge to main

# Deploy to staging
git checkout staging
git merge main
git push origin staging

# Deploy to production
git checkout production
git merge main
git push origin production
```

## Git Configuration

### Advanced Configuration
```bash
# Performance settings
git config --global core.preloadindex true
git config --global core.fscache true
git config --global gc.auto 256

# Security settings
git config --global user.signingkey YOUR_GPG_KEY_ID
git config --global commit.gpgsign true
git config --global tag.gpgsign true

# Diff and merge tools
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# URL shortcuts
git config --global url."git@github.com:".insteadOf "https://github.com/"
git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"

# Aliases (see aliases section below)
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
```

### Useful Git Aliases
```bash
# Basic shortcuts
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit

# Advanced aliases
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'

# Complex aliases
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.contributors "shortlog --summary --numbered"
git config --global alias.delete-merged-branches "!git branch --merged | grep -v '\\*\\|main\\|develop' | xargs -n 1 git branch -d"
```

### Global .gitignore
```bash
# Create global gitignore
git config --global core.excludesfile ~/.gitignore_global

# Common global gitignore patterns
cat > ~/.gitignore_global << 'EOF'
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Temporary files
tmp/
temp/
EOF
```

## Project-Specific Git Configuration

### Repository .gitignore
```bash
# Node.js project
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
build/
dist/
coverage/

# Python project
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/
.env
.venv
pip-log.txt
pip-delete-this-directory.txt

# Java project
*.class
*.jar
*.war
*.ear
target/
*.iml
.idea/

# C/C++ project
*.o
*.obj
*.exe
*.dll
*.so
*.dylib
*.a
*.lib
build/
dist/

# General development
*.log
*.tmp
*.temp
.cache/
.temp/
```

### Git Hooks
```bash
# Enable hooks
chmod +x .git/hooks/pre-commit

# Pre-commit hook example
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
# Run tests before commit
npm test
if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

# Check for TODO comments
if git diff --cached | grep -q "TODO\|FIXME"; then
  echo "Warning: TODO or FIXME found in staged changes"
  echo "Continue? (y/n)"
  read answer
  if [ "$answer" != "y" ]; then
    exit 1
  fi
fi
EOF

# Commit message hook
cat > .git/hooks/commit-msg << 'EOF'
#!/bin/sh
# Check commit message format
commit_regex='^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
    echo "Invalid commit message format!"
    echo "Format: type(scope): description"
    echo "Types: feat, fix, docs, style, refactor, test, chore"
    exit 1
fi
EOF
```

## Advanced Git Operations

### Interactive Rebase
```bash
# Interactive rebase for cleaning history
git rebase -i HEAD~3

# Rebase options in editor:
# pick = use commit
# reword = use commit, but edit message
# edit = use commit, but stop for amending
# squash = use commit, but meld into previous commit
# fixup = like squash, but discard commit message
# exec = run command
# drop = remove commit

# Example interactive rebase session:
pick f7f3f6d Change my name a bit
pick 310154e Update README formatting
squash a5f4a0d Add forgotten file
pick 3c4e9b3 Add final touches
```

### Bisecting for Bug Hunting
```bash
# Start bisecting
git bisect start
git bisect bad                    # Current commit is bad
git bisect good v1.0             # Known good commit

# Git will checkout middle commit
# Test and mark as good or bad
git bisect good                  # If test passes
git bisect bad                   # If test fails

# Continue until bug is found
git bisect reset                 # End bisect session

# Automated bisecting
git bisect start HEAD v1.0
git bisect run npm test         # Automatically run tests
```

### Submodules Management
```bash
# Add submodule
git submodule add https://github.com/user/repo.git path/to/submodule

# Initialize submodules after cloning
git submodule init
git submodule update
# or
git submodule update --init --recursive

# Update submodules
git submodule update --remote
git submodule foreach git pull origin main

# Remove submodule
git submodule deinit path/to/submodule
git rm path/to/submodule
rm -rf .git/modules/path/to/submodule
```

### Worktrees for Multiple Branches
```bash
# Create worktree
git worktree add ../project-feature feature-branch
git worktree add --checkout ../project-bugfix -b bugfix-branch

# List worktrees
git worktree list

# Remove worktree
git worktree remove ../project-feature
git worktree prune                # Clean up deleted worktrees
```

## Git Performance Optimization

### Repository Maintenance
```bash
# Garbage collection
git gc                           # Standard cleanup
git gc --aggressive             # Thorough cleanup (slow)
git gc --auto                   # Automatic cleanup

# Prune operations
git prune                       # Remove unreachable objects
git remote prune origin         # Remove tracking branches
git fetch --prune              # Prune during fetch

# Repository optimization
git repack -a -d --depth=250 --window=250
git fsck --full                # Check repository integrity
```

### Large File Handling
```bash
# Git LFS setup
git lfs install
git lfs track "*.psd"           # Track large files
git add .gitattributes

# Add and commit large files
git add large-file.psd
git commit -m "Add design file"

# Clone with LFS
git lfs clone https://github.com/user/repo.git

# Migrate existing files to LFS
git lfs migrate import --include="*.zip,*.tar.gz"
```

### Shallow Clones
```bash
# Shallow clone (faster for large repos)
git clone --depth 1 https://github.com/user/repo.git
git clone --shallow-since="2023-01-01" https://github.com/user/repo.git

# Unshallow repository
git fetch --unshallow

# Partial clone (Git 2.19+)
git clone --filter=blob:none https://github.com/user/repo.git
git clone --filter=tree:0 https://github.com/user/repo.git
```

## Security and Signing

### GPG Signing Setup
```bash
# Generate GPG key
gpg --gen-key

# List GPG keys
gpg --list-secret-keys --keyid-format LONG

# Configure Git to use GPG
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
git config --global tag.gpgsign true

# Sign specific commits
git commit -S -m "Signed commit"
git tag -s v1.0 -m "Signed tag"

# Verify signatures
git log --show-signature
git verify-commit HEAD
git verify-tag v1.0
```

### SSH Key Setup
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"  # Legacy

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Test connection
ssh -T git@github.com
ssh -T git@gitlab.com

# Configure multiple SSH keys
cat > ~/.ssh/config << 'EOF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github

Host gitlab.com
  HostName gitlab.com
  User git
  IdentityFile ~/.ssh/id_ed25519_gitlab
EOF
```

## Troubleshooting

### Common Issues & Solutions

**Issue**: Merge conflicts
**Cause**: Conflicting changes in the same lines
**Solution**:
```bash
# View conflicts
git status
git diff

# Resolve manually or use merge tool
git mergetool

# Mark as resolved and commit
git add resolved-file.txt
git commit
```

**Issue**: Accidentally committed sensitive data
**Cause**: Added passwords, keys, or secrets to repository
**Solution**:
```bash
# Remove from last commit
git reset --soft HEAD~1
git reset HEAD sensitive-file.txt
git commit

# Remove from history (dangerous)
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch sensitive-file.txt' \
  --prune-empty --tag-name-filter cat -- --all

# Modern alternative with git-filter-repo
git filter-repo --path sensitive-file.txt --invert-paths
```

**Issue**: Large repository size
**Cause**: Large files or long history
**Solution**:
```bash
# Find large files
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | grep '^blob' | sort -nk3 | tail -20

# Clean up with BFG
java -jar bfg.jar --strip-blobs-bigger-than 50M my-repo.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

### Debug Commands
```bash
# Debug information
git status --porcelain
git ls-files --stage
git cat-file -p HEAD

# Network debugging
GIT_CURL_VERBOSE=1 git push
GIT_SSH_COMMAND="ssh -vvv" git push

# Trace execution
GIT_TRACE=1 git status
GIT_TRACE_PACK_ACCESS=1 git log
```

## Best Practices

### Commit Guidelines
- Write clear, descriptive commit messages
- Use present tense ("Add feature" not "Added feature")
- Keep commits atomic (one logical change per commit)
- Reference issues in commit messages (#123)
- Use conventional commit format for automation

### Branch Strategy
- Use descriptive branch names (feature/user-auth, fix/login-bug)
- Delete merged branches to keep repository clean
- Use pull/merge requests for code review
- Protect main/master branch from direct pushes
- Regular integration to avoid long-lived branches

### Repository Hygiene
- Keep .gitignore updated and comprehensive
- Use .gitattributes for binary files and line endings
- Regular repository maintenance (gc, prune)
- Monitor repository size and optimize as needed
- Document branching strategy and workflows

### Security Practices
- Never commit sensitive data (passwords, keys, tokens)
- Use GPG signing for important commits and tags
- Regularly rotate SSH keys and access tokens
- Review commit history for accidental sensitive data
- Use branch protection rules and required reviews

## Useful Resources
- **Official Documentation**: https://git-scm.com/doc
- **Pro Git Book**: https://git-scm.com/book
- **Git Tutorial**: https://learngitbranching.js.org/
- **GitHub Guides**: https://guides.github.com/
- **Git Cheat Sheet**: https://education.github.com/git-cheat-sheet-education.pdf

## Tool-Specific Guidelines

### Version Compatibility
- **Git**: 2.40+ for modern features and security updates
- **GitHub CLI**: Latest version for GitHub integration
- **GitLab CLI**: Latest version for GitLab integration

### Integration Tools
- Use with IDEs for visual Git operations
- Integrate with CI/CD pipelines for automated workflows
- Combine with code review tools for quality gates
- Use hooks for automated quality checks
- Leverage GUI tools for complex operations when needed
````
