````instructions
# EditorConfig Instructions

## Tool Overview
- **Tool Name**: EditorConfig
- **Version**: 0.12+ (stable), latest specification maintained
- **Category**: Development Tools
- **Purpose**: Maintain consistent coding styles across different editors and IDEs
- **Prerequisites**: Editor/IDE with EditorConfig plugin support (most modern editors included)

## Installation & Setup
### Editor Plugin Installation
```bash
# VS Code (usually pre-installed)
code --install-extension EditorConfig.EditorConfig

# Vim/Neovim
Plugin 'editorconfig/editorconfig-vim'

# Sublime Text
Package Control: Install Package -> EditorConfig

# Atom
apm install editorconfig

# IntelliJ IDEA/WebStorm (built-in support)
# No installation needed for JetBrains IDEs

# Emacs
M-x package-install RET editorconfig RET
```

### Project Integration
```bash
# Create EditorConfig file in project root
touch .editorconfig

# Verify editor support
# Most editors automatically detect and apply .editorconfig

# Test configuration
echo "test content" > test.js
# Check if editor applies configured settings
```

### Basic Configuration
```ini
# .editorconfig - Basic setup
root = true

[*]
charset = utf-8
end_of_line = lf
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true

[*.{js,jsx,ts,tsx}]
indent_size = 2

[*.{py,pyw}]
indent_size = 4

[*.md]
trim_trailing_whitespace = false
```

### Comprehensive Configuration
```ini
# .editorconfig - Comprehensive setup
root = true

# Default settings for all files
[*]
charset = utf-8
end_of_line = lf
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true
max_line_length = 80

# JavaScript/TypeScript files
[*.{js,jsx,mjs,cjs}]
indent_size = 2
max_line_length = 100

[*.{ts,tsx}]
indent_size = 2
max_line_length = 100

# JSON files
[*.json]
indent_size = 2

# CSS/SCSS/LESS files
[*.{css,scss,sass,less}]
indent_size = 2

# HTML files
[*.{html,htm}]
indent_size = 2

# XML files
[*.{xml,svg}]
indent_size = 2

# Python files
[*.{py,pyw}]
indent_size = 4
max_line_length = 88

# Go files
[*.go]
indent_style = tab
indent_size = 4

# Rust files
[*.rs]
indent_size = 4
max_line_length = 100

# C/C++ files
[*.{c,cpp,cc,cxx,h,hpp}]
indent_size = 4

# Java files
[*.java]
indent_size = 4

# C# files
[*.cs]
indent_size = 4

# PHP files
[*.php]
indent_size = 4

# Ruby files
[*.rb]
indent_size = 2

# YAML files
[*.{yml,yaml}]
indent_size = 2

# TOML files
[*.toml]
indent_size = 2

# Makefile
[Makefile]
indent_style = tab

# Markdown files
[*.md]
trim_trailing_whitespace = false
max_line_length = 80

# Shell scripts
[*.{sh,bash,zsh}]
indent_size = 2

# Configuration files
[*.{ini,cfg,conf}]
indent_size = 2

# Docker files
[Dockerfile*]
indent_size = 2

[*.dockerfile]
indent_size = 2

# Batch files
[*.{bat,cmd}]
end_of_line = crlf

# PowerShell files
[*.ps1]
end_of_line = crlf
```

## Core Features

### Indentation Control
- **Purpose**: Ensure consistent indentation across team and editors
- **Usage**: Configure spaces vs tabs and indentation size
- **Example**:

```ini
# Different indentation styles for different languages
[*.{js,ts,json,css}]
indent_style = space
indent_size = 2

[*.{py,java,c,cpp}]
indent_style = space
indent_size = 4

[*.go]
indent_style = tab
indent_size = 4

[Makefile]
indent_style = tab
```

**Before EditorConfig:**
```javascript
// Inconsistent indentation
function example() {
    const data = {
      name: 'test',
        value: 42
    };
      return data;
}
```

**After EditorConfig:**
```javascript
// Consistent indentation
function example() {
  const data = {
    name: 'test',
    value: 42
  };
  return data;
}
```

### Line Ending Normalization
- **Purpose**: Standardize line endings across different operating systems
- **Usage**: Configure LF, CRLF, or CR line endings
- **Example**:

```ini
# Cross-platform configuration
[*]
end_of_line = lf  # Unix/Linux/macOS standard

# Windows-specific files
[*.{bat,cmd,ps1}]
end_of_line = crlf

# Legacy Mac files (rarely needed)
[*.classic]
end_of_line = cr
```

### Character Encoding
- **Purpose**: Ensure consistent character encoding across files
- **Usage**: Standardize UTF-8 encoding for modern projects
- **Example**:

```ini
[*]
charset = utf-8

# Special cases for legacy systems
[*.{legacy,old}]
charset = latin1

# BOM handling for specific files
[*.{txt,csv}]
charset = utf-8-bom
```

### Whitespace Management
- **Purpose**: Control trailing whitespace and final newlines
- **Usage**: Automatically clean up common whitespace issues
- **Example**:

```ini
[*]
trim_trailing_whitespace = true
insert_final_newline = true

# Exception for markdown (trailing spaces have meaning)
[*.md]
trim_trailing_whitespace = false

# Exception for diff files
[*.{diff,patch}]
trim_trailing_whitespace = false
```

## Language-Specific Configurations

### Web Development
```ini
# .editorconfig - Web development optimized
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# Frontend languages
[*.{html,htm}]
indent_style = space
indent_size = 2

[*.{css,scss,sass,less}]
indent_style = space
indent_size = 2

[*.{js,jsx,mjs,cjs}]
indent_style = space
indent_size = 2
max_line_length = 100

[*.{ts,tsx}]
indent_style = space
indent_size = 2
max_line_length = 100

[*.{vue,svelte}]
indent_style = space
indent_size = 2

# Configuration files
[*.{json,jsonc}]
indent_style = space
indent_size = 2

[package.json]
indent_style = space
indent_size = 2

# Build tool configs
[*.{webpack,rollup,vite}.config.{js,ts}]
indent_style = space
indent_size = 2

# Testing files
[*.{test,spec}.{js,ts,jsx,tsx}]
indent_style = space
indent_size = 2

# Documentation
[*.md]
indent_style = space
indent_size = 2
trim_trailing_whitespace = false
```

### Backend Development
```ini
# .editorconfig - Backend development
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# Node.js/Express
[*.{js,mjs,cjs}]
indent_style = space
indent_size = 2

[*.ts]
indent_style = space
indent_size = 2

# Python/Django
[*.{py,pyw}]
indent_style = space
indent_size = 4
max_line_length = 88

# Java/Spring
[*.java]
indent_style = space
indent_size = 4
max_line_length = 120

# C#/.NET
[*.cs]
indent_style = space
indent_size = 4

# Go
[*.go]
indent_style = tab
indent_size = 4

# Rust
[*.rs]
indent_style = space
indent_size = 4
max_line_length = 100

# PHP
[*.php]
indent_style = space
indent_size = 4

# SQL files
[*.sql]
indent_style = space
indent_size = 2

# Configuration files
[*.{yml,yaml}]
indent_style = space
indent_size = 2

[*.toml]
indent_style = space
indent_size = 2

[*.{ini,cfg,conf}]
indent_style = space
indent_size = 2
```

### Mobile Development
```ini
# .editorconfig - Mobile development
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# React Native
[*.{js,jsx,ts,tsx}]
indent_style = space
indent_size = 2

# iOS/Swift
[*.swift]
indent_style = space
indent_size = 4

# Android/Kotlin
[*.{kt,kts}]
indent_style = space
indent_size = 4

# Android/Java
[*.java]
indent_style = space
indent_size = 4

# Flutter/Dart
[*.dart]
indent_style = space
indent_size = 2

# Gradle files
[*.gradle]
indent_style = space
indent_size = 4

[*.{gradle.kts}]
indent_style = space
indent_size = 4

# XML files (Android layouts)
[*.xml]
indent_style = space
indent_size = 4

# Plist files (iOS)
[*.plist]
indent_style = space
indent_size = 2
```

## Advanced Features

### File Pattern Matching
```ini
# .editorconfig - Advanced pattern matching
root = true

# Global defaults
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# Specific file extensions
[*.{js,jsx,ts,tsx,vue,svelte}]
indent_style = space
indent_size = 2

# Multiple extensions with different rules
[*.{html,htm,xml,svg}]
indent_style = space
indent_size = 2

# Directory-specific patterns
[src/**/*.{js,ts}]
max_line_length = 100

[tests/**/*.{js,ts}]
max_line_length = 120

# Filename patterns
[*config*.{js,ts,json}]
indent_size = 2

[*.min.{js,css}]
insert_final_newline = false
trim_trailing_whitespace = false

# Complex patterns
[{package,bower,component}.json]
indent_size = 2

[{Gruntfile,gulpfile,webpack.config}.js]
indent_size = 2

# Negation patterns (not supported directly, but can be worked around)
[*.{js,ts}]
indent_size = 2

[*.min.{js,ts}]
# Override for minified files
indent_size = unset
```

### Environment-Specific Configuration
```ini
# .editorconfig - Environment specific
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

# Development files
[src/**/*]
max_line_length = 100

# Production builds
[dist/**/*]
insert_final_newline = false
trim_trailing_whitespace = false

# Test files
[{test,tests,spec,__tests__}/**/*]
max_line_length = 120

# Documentation
[{docs,documentation}/**/*.md]
max_line_length = 80
trim_trailing_whitespace = false

# Configuration directories
[{config,configs}/**/*]
indent_size = 2

# Scripts directory
[{script,scripts}/**/*.{sh,bash,zsh}]
indent_size = 2
```

### Legacy and Migration Support
```ini
# .editorconfig - Legacy support
root = true

# Modern defaults
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

# Legacy files that shouldn't be changed
[legacy/**/*]
charset = unset
end_of_line = unset
insert_final_newline = unset
trim_trailing_whitespace = unset
indent_style = unset
indent_size = unset

# Vendor/third-party code
[{vendor,node_modules,lib}/**/*]
charset = unset
end_of_line = unset
insert_final_newline = unset
trim_trailing_whitespace = unset

# Generated files
[*.generated.*]
insert_final_newline = false
trim_trailing_whitespace = false

# Binary-like files
[*.{min.js,min.css,bundle.js}]
insert_final_newline = false
trim_trailing_whitespace = false
```

## Framework-Specific Configurations

### React/Next.js Projects
```ini
# .editorconfig - React/Next.js
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# React components
[*.{js,jsx,ts,tsx}]
indent_style = space
indent_size = 2
max_line_length = 100

# Next.js specific files
[{pages,app}/**/*.{js,jsx,ts,tsx}]
indent_style = space
indent_size = 2

[next.config.{js,mjs}]
indent_style = space
indent_size = 2

# Styling
[*.{css,scss,sass,module.css,module.scss}]
indent_style = space
indent_size = 2

# Configuration
[*.{json,jsonc}]
indent_style = space
indent_size = 2

[package.json]
indent_style = space
indent_size = 2

# Tailwind
[tailwind.config.{js,ts}]
indent_style = space
indent_size = 2

# PostCSS
[postcss.config.{js,cjs}]
indent_style = space
indent_size = 2
```

### Vue.js Projects
```ini
# .editorconfig - Vue.js
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# Vue files
[*.vue]
indent_style = space
indent_size = 2

# JavaScript/TypeScript
[*.{js,ts}]
indent_style = space
indent_size = 2

# Vue configuration
[vue.config.js]
indent_style = space
indent_size = 2

[vite.config.{js,ts}]
indent_style = space
indent_size = 2

# Nuxt.js
[nuxt.config.{js,ts}]
indent_style = space
indent_size = 2

# Quasar
[quasar.config.js]
indent_style = space
indent_size = 2
```

### Angular Projects
```ini
# .editorconfig - Angular
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# TypeScript files
[*.ts]
indent_style = space
indent_size = 2
max_line_length = 140

# HTML templates
[*.html]
indent_style = space
indent_size = 2

# SCSS files
[*.{css,scss}]
indent_style = space
indent_size = 2

# Angular JSON files
[*.json]
indent_style = space
indent_size = 2

# Angular configuration
[angular.json]
indent_style = space
indent_size = 2

[*.component.{ts,html,scss}]
indent_style = space
indent_size = 2

[*.service.ts]
indent_style = space
indent_size = 2

[*.module.ts]
indent_style = space
indent_size = 2
```

## Integration with Development Tools

### Integration with Prettier
```ini
# .editorconfig - Works with Prettier
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# Let Prettier handle formatting, EditorConfig handles basics
[*.{js,jsx,ts,tsx,json,css,scss,md}]
indent_style = space
indent_size = 2
# Prettier will override specific formatting rules

# Files Prettier doesn't handle
[*.{py,java,c,cpp,go,rs}]
indent_style = space
indent_size = 4
```

### Integration with ESLint
```ini
# .editorconfig - ESLint compatible
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# Align with ESLint rules
[*.{js,jsx,ts,tsx}]
indent_style = space
indent_size = 2  # Should match ESLint indent rule
max_line_length = 100  # Should match ESLint max-len rule
```

### Integration with Language Servers
```ini
# .editorconfig - Language server compatible
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# TypeScript Language Server
[*.{ts,tsx}]
indent_style = space
indent_size = 2

# Python Language Server
[*.py]
indent_style = space
indent_size = 4
max_line_length = 88

# Go Language Server
[*.go]
indent_style = tab
indent_size = 4

# Rust Language Server
[*.rs]
indent_style = space
indent_size = 4
```

## Team Collaboration

### Monorepo Configuration
```ini
# .editorconfig - Monorepo root
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

# Global defaults
[*.{js,jsx,ts,tsx}]
indent_style = space
indent_size = 2

# Package-specific overrides can be in individual .editorconfig files
# packages/frontend/.editorconfig
# packages/backend/.editorconfig
# packages/mobile/.editorconfig

# Shared configurations
[{packages,apps,libs}/**/*.{js,ts}]
indent_style = space
indent_size = 2

# Root level files
[{package.json,lerna.json,nx.json}]
indent_style = space
indent_size = 2
```

### Organization Standards
```ini
# .editorconfig - Organization-wide standards
root = true

# Global company standards
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
max_line_length = 120

# Frontend team standards
[*.{js,jsx,ts,tsx,vue,svelte}]
indent_style = space
indent_size = 2

# Backend team standards
[*.{java,py,cs,go,rs}]
indent_style = space
indent_size = 4

# DevOps team standards
[*.{yml,yaml,dockerfile,sh}]
indent_style = space
indent_size = 2

# Documentation standards
[*.md]
indent_style = space
indent_size = 2
trim_trailing_whitespace = false
max_line_length = 80
```

## Common Commands and Validation

### Validation Tools
```bash
# Install editorconfig-checker
npm install -g editorconfig-checker

# Check files against .editorconfig
ec

# Check specific files
ec src/**/*.js

# Check with verbose output
ec -verbose

# Exclude files/directories
ec -exclude "node_modules|dist"

# Use in CI/CD
ec -no-color
```

### Integration Scripts
```bash
#!/bin/bash
# validate-editorconfig.sh

echo "Validating EditorConfig compliance..."

# Check if .editorconfig exists
if [ ! -f ".editorconfig" ]; then
  echo "❌ No .editorconfig file found"
  exit 1
fi

# Validate using editorconfig-checker
if command -v ec &> /dev/null; then
  ec
  if [ $? -eq 0 ]; then
    echo "✅ All files comply with EditorConfig"
  else
    echo "❌ EditorConfig violations found"
    exit 1
  fi
else
  echo "⚠️ editorconfig-checker not installed"
  echo "Install with: npm install -g editorconfig-checker"
fi
```

### Git Hooks Integration
```bash
# .husky/pre-commit
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🔍 Checking EditorConfig compliance..."

# Check staged files
STAGED_FILES=$(git diff --cached --name-only)

if [ -n "$STAGED_FILES" ]; then
  # Use editorconfig-checker on staged files
  echo "$STAGED_FILES" | xargs ec

  if [ $? -ne 0 ]; then
    echo "❌ EditorConfig violations in staged files"
    echo "Fix the issues or use 'git commit --no-verify' to skip"
    exit 1
  fi
fi

echo "✅ EditorConfig compliance check passed"
```

## IDE-Specific Support

### VS Code Integration
```json
// .vscode/settings.json
{
  "editorconfig.generateAuto": false,
  "files.insertFinalNewline": true,
  "files.trimTrailingWhitespace": true,
  "editor.insertSpaces": true,
  "editor.tabSize": 2,
  "editor.detectIndentation": false,
  "files.eol": "\n"
}
```

### JetBrains IDEs
```xml
<!-- .idea/codeStyles/Project.xml -->
<component name="ProjectCodeStyleConfiguration">
  <code_scheme name="Project" version="173">
    <option name="LINE_SEPARATOR" value="&#10;" />
    <option name="RIGHT_MARGIN" value="100" />
    <JSCodeStyleSettings version="0">
      <option name="USE_SEMICOLON_AFTER_STATEMENT" value="true" />
      <option name="FORCE_SEMICOLON_STYLE" value="true" />
      <option name="USE_DOUBLE_QUOTES" value="false" />
      <option name="SPACES_WITHIN_OBJECT_LITERAL_BRACES" value="true" />
    </JSCodeStyleSettings>
  </code_scheme>
</component>
```

### Vim/Neovim Configuration
```vim
" .vimrc - EditorConfig integration
if has('autocmd')
  autocmd FileType * setlocal formatoptions-=cro
endif

" Respect EditorConfig settings
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Custom settings that work with EditorConfig
set number
set relativenumber
set showmatch
set hlsearch
```

## Troubleshooting

### Common Issues

**Issue**: Settings not being applied
**Cause**: Editor doesn't support EditorConfig or plugin not installed
**Solution**:
```bash
# Check if your editor has EditorConfig support
# Install appropriate plugin for your editor
# VS Code: EditorConfig.EditorConfig
# Sublime: EditorConfig package
# Vim: editorconfig-vim plugin
```

**Issue**: Conflicting settings with other tools
**Cause**: Other formatting tools overriding EditorConfig
**Solution**:
```ini
# Ensure EditorConfig and other tools agree
[*.js]
indent_style = space
indent_size = 2
# Make sure Prettier, ESLint configs match
```

**Issue**: Windows line ending issues
**Cause**: Git or editor changing line endings
**Solution**:
```bash
# Configure Git to respect EditorConfig
git config core.autocrlf false
git config core.eol lf

# Normalize existing files
git add --renormalize .
```

### Debug Configuration
```bash
# Test EditorConfig parsing
python -c "
import editorconfig
import sys
properties = editorconfig.get_properties(sys.argv[1])
for key, value in properties.items():
    print(f'{key}: {value}')
" path/to/file.js
```

## Best Practices

### Configuration Guidelines
- Always include `root = true` in the main .editorconfig
- Use specific patterns rather than overly broad ones
- Document any unusual configuration choices
- Keep settings consistent with team's style guides
- Regular reviews of EditorConfig effectiveness

### Performance Considerations
- Avoid overly complex glob patterns
- Use specific file extensions rather than wildcards when possible
- Place .editorconfig files close to the files they affect
- Don't override settings unnecessarily

### Team Adoption
- Ensure all team members have EditorConfig support in their editors
- Document the reasoning behind specific configuration choices
- Provide setup instructions for different editors
- Include EditorConfig validation in CI/CD pipelines
- Regular team discussions about style preferences

### Maintenance
- Keep EditorConfig files in version control
- Update configurations when adding new file types
- Regularly validate configuration effectiveness
- Monitor for conflicts with other development tools
- Periodic cleanup of unused or outdated rules

## Useful Resources
- **Official Website**: https://editorconfig.org/
- **Specification**: https://editorconfig-specification.readthedocs.io/
- **Plugin List**: https://editorconfig.org/#download
- **Validation Tool**: https://github.com/editorconfig-checker/editorconfig-checker
- **Examples**: https://github.com/editorconfig/editorconfig/wiki/Projects-Using-EditorConfig

## Tool-Specific Guidelines

### Supported Properties
- `indent_style`: tab or space
- `indent_size`: number or tab
- `tab_width`: number
- `end_of_line`: lf, crlf, or cr
- `charset`: utf-8, utf-8-bom, latin1, utf-16be, utf-16le
- `trim_trailing_whitespace`: true or false
- `insert_final_newline`: true or false
- `max_line_length`: number

### Compatibility Notes
- Not all editors support all properties
- Some properties are editor-specific extensions
- Check your editor's documentation for full support details
- Use `unset` to remove inherited properties
- Consider fallback values for better compatibility
````
