````instructions
# Husky Git Hooks Instructions

## Tool Overview
- **Tool Name**: Husky
- **Version**: 9.0+ (stable), 9.1+ (latest with enhanced features)
- **Category**: Development Tools
- **Purpose**: Modern native Git hooks that improve your commits and more
- **Prerequisites**: Node.js 18+ (20+ recommended), Git 2.13+, npm/yarn/pnpm

## Installation & Setup
### Package Manager Installation
```bash
# npm installation
npm install --save-dev husky
npm install -g husky  # Global installation (not recommended)

# yarn installation
yarn add --dev husky

# pnpm installation
pnpm add -D husky

# Verify installation
npx husky --version
```

### Project Integration
```bash
# Initialize Husky in your project
npx husky init

# Manual setup (if init doesn't work)
npx husky install

# Add Husky to package.json scripts
npm pkg set scripts.prepare="husky install"

# Make .husky directory executable
chmod +x .husky/*

# Verify setup
npx husky --help
```

### Basic Configuration
```json
// package.json - Basic Husky setup
{
  "name": "my-project",
  "scripts": {
    "prepare": "husky install",
    "test": "jest",
    "lint": "eslint src/",
    "format": "prettier --write ."
  },
  "devDependencies": {
    "husky": "^9.1.0",
    "lint-staged": "^15.0.0",
    "prettier": "^3.0.0",
    "eslint": "^8.50.0"
  }
}
```

### Initial Hook Setup
```bash
# Create pre-commit hook
npx husky add .husky/pre-commit "npm test"

# Create commit-msg hook
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit "$1"'

# Create pre-push hook
npx husky add .husky/pre-push "npm run build"

# Make hooks executable
chmod +x .husky/pre-commit .husky/commit-msg .husky/pre-push
```

## Core Features

### Pre-commit Hooks
- **Purpose**: Run checks before commits are created
- **Usage**: Validate code quality, formatting, and tests
- **Example**:

```bash
# .husky/pre-commit
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🔍 Running pre-commit checks..."

# Run linting
echo "Checking code style..."
npm run lint

# Run tests
echo "Running tests..."
npm test

# Run type checking
echo "Type checking..."
npm run type-check

# Format code
echo "Formatting code..."
npm run format

echo "✅ Pre-commit checks passed!"
```

### Commit Message Validation
- **Purpose**: Enforce conventional commit message format
- **Usage**: Validate commit messages before they're saved
- **Example**:

```bash
# .husky/commit-msg
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🔍 Validating commit message..."

# Using commitlint
npx --no -- commitlint --edit "$1"

# Custom validation script
node scripts/validate-commit-message.js "$1"
```

```javascript
// scripts/validate-commit-message.js
const fs = require('fs');
const path = require('path');

const commitMsgFile = process.argv[2];
const commitMsg = fs.readFileSync(path.resolve(commitMsgFile), 'utf8').trim();

// Conventional commit pattern
const conventionalCommitRegex = /^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?: .{1,50}/;

if (!conventionalCommitRegex.test(commitMsg)) {
  console.error(`
❌ Invalid commit message format!

Expected format: <type>(<scope>): <description>

Examples:
  feat(auth): add user authentication
  fix(api): resolve login endpoint issue
  docs: update README installation steps

Types: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert
  `);
  process.exit(1);
}

console.log('✅ Commit message format is valid!');
```

### Pre-push Hooks
- **Purpose**: Run checks before code is pushed to remote repository
- **Usage**: Final validation including builds and comprehensive tests
- **Example**:

```bash
# .husky/pre-push
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🚀 Running pre-push checks..."

# Check if on main branch
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  echo "🚨 Direct push to $branch is not allowed!"
  echo "Please create a feature branch and submit a pull request."
  exit 1
fi

# Run comprehensive tests
echo "Running full test suite..."
npm run test:coverage

# Build project
echo "Building project..."
npm run build

# Security audit
echo "Running security audit..."
npm audit --audit-level high

# Bundle size check
echo "Checking bundle size..."
npm run bundle:analyze

echo "✅ Pre-push checks passed!"
```

### Post-commit Hooks
- **Purpose**: Run actions after a commit is created
- **Usage**: Notifications, documentation generation, cleanup
- **Example**:

```bash
# .husky/post-commit
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "📝 Post-commit actions..."

# Generate documentation
npm run docs:generate

# Update changelog
npm run changelog:update

# Notify team (optional)
# node scripts/notify-team.js

echo "✅ Post-commit actions completed!"
```

## Advanced Features

### Integration with Lint-staged
- **Purpose**: Run linters only on staged files for better performance
- **Usage**: Combine Husky with lint-staged for efficient pre-commit hooks
- **Example**:

```bash
# Install lint-staged
npm install --save-dev lint-staged
```

```json
// package.json - lint-staged configuration
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,css,scss,md,html}": [
      "prettier --write"
    ],
    "*.{png,jpg,jpeg,gif,svg}": [
      "imagemin-lint-staged"
    ]
  }
}
```

```bash
# .husky/pre-commit - Using lint-staged
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🔍 Running lint-staged..."
npx lint-staged

echo "🧪 Running tests on staged files..."
npm run test:staged

echo "✅ Pre-commit checks passed!"
```

### Conditional Hook Execution
- **Purpose**: Run hooks based on specific conditions
- **Usage**: Skip hooks in certain scenarios or environments
- **Example**:

```bash
# .husky/pre-commit - Conditional execution
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# Skip hooks in CI environment
if [ "$CI" = "true" ]; then
  echo "⏭️ Skipping pre-commit hooks in CI environment"
  exit 0
fi

# Skip hooks with --no-verify flag check
if [ "$HUSKY_SKIP_HOOKS" = "1" ]; then
  echo "⏭️ Skipping pre-commit hooks (HUSKY_SKIP_HOOKS=1)"
  exit 0
fi

# Check if this is a merge commit
if git rev-parse --verify MERGE_HEAD >/dev/null 2>&1; then
  echo "⏭️ Skipping pre-commit hooks for merge commit"
  exit 0
fi

echo "🔍 Running pre-commit checks..."
npx lint-staged
npm run test:quick
```

### Multi-language Project Support
- **Purpose**: Handle projects with multiple programming languages
- **Usage**: Configure hooks for different language ecosystems
- **Example**:

```bash
# .husky/pre-commit - Multi-language support
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🔍 Running multi-language checks..."

# Check if JavaScript/TypeScript files changed
if git diff --cached --name-only | grep -E '\.(js|jsx|ts|tsx)$' > /dev/null; then
  echo "📦 JavaScript/TypeScript files detected..."
  npm run lint:js
  npm run test:js
fi

# Check if Python files changed
if git diff --cached --name-only | grep -E '\.py$' > /dev/null; then
  echo "🐍 Python files detected..."
  python -m flake8 src/
  python -m pytest tests/ -x
fi

# Check if Go files changed
if git diff --cached --name-only | grep -E '\.go$' > /dev/null; then
  echo "🐹 Go files detected..."
  go fmt ./...
  go vet ./...
  go test ./...
fi

# Check if Rust files changed
if git diff --cached --name-only | grep -E '\.rs$' > /dev/null; then
  echo "🦀 Rust files detected..."
  cargo fmt --all -- --check
  cargo clippy -- -D warnings
  cargo test
fi

echo "✅ Multi-language checks passed!"
```

## Common Commands
```bash
# Husky management
husky install                          # Install hooks
husky uninstall                        # Uninstall hooks
husky add <file> [cmd]                 # Add new hook
husky set <file> [cmd]                 # Update existing hook

# Hook management
npx husky add .husky/pre-commit "npm test"        # Add pre-commit hook
npx husky add .husky/commit-msg "npx commitlint"  # Add commit-msg hook
npx husky add .husky/pre-push "npm run build"     # Add pre-push hook

# Skip hooks temporarily
git commit --no-verify                 # Skip pre-commit and commit-msg hooks
git push --no-verify                   # Skip pre-push hooks
HUSKY_SKIP_HOOKS=1 git commit          # Skip all hooks with environment variable

# Debug hooks
npx husky install --debug              # Install with debug information
HUSKY_DEBUG=1 git commit               # Run hooks in debug mode

# Hook utilities
chmod +x .husky/*                      # Make all hooks executable
ls -la .husky/                         # List all hooks
cat .husky/pre-commit                  # View hook content
```

## Enterprise Configuration

### Team Development Setup
```bash
# .husky/pre-commit - Enterprise team setup
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🏢 Running enterprise pre-commit checks..."

# Security scanning
echo "🔐 Running security scan..."
npm audit --audit-level high
npx semgrep scan --config=auto src/

# Code quality gates
echo "📊 Checking code quality metrics..."
npx sonarjs-verify-coverage
npm run complexity:check

# License compliance
echo "📄 Checking license compliance..."
npx license-checker --summary

# Dependency vulnerability check
echo "🛡️ Checking dependencies..."
npx npm-audit-ci --threshold 7

# Performance regression check
echo "⚡ Performance regression check..."
npm run perf:check

echo "✅ Enterprise checks passed!"
```

### Monorepo Configuration
```bash
# .husky/pre-commit - Monorepo setup
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "📦 Running monorepo pre-commit checks..."

# Get list of changed packages
CHANGED_PACKAGES=$(npx lerna changed --parseable | sed 's/.*packages\///g')

if [ -z "$CHANGED_PACKAGES" ]; then
  echo "ℹ️ No packages changed, skipping checks"
  exit 0
fi

echo "📋 Changed packages: $CHANGED_PACKAGES"

# Run checks only on changed packages
for package in $CHANGED_PACKAGES; do
  echo "🔍 Checking package: $package"

  # Navigate to package directory
  cd "packages/$package" || exit 1

  # Run package-specific checks
  npm run lint
  npm run test
  npm run type-check

  # Return to root
  cd - > /dev/null || exit 1
done

# Run root-level checks
echo "🌳 Running root-level checks..."
npm run build:all
npm run test:integration

echo "✅ Monorepo checks passed!"
```

### CI/CD Integration
```bash
# .husky/pre-push - CI/CD integration
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# Skip in CI environments
if [ "$CI" = "true" ]; then
  echo "⏭️ Skipping pre-push hooks in CI environment"
  exit 0
fi

echo "🚀 Running CI/CD pre-push checks..."

# Validate CI configuration
echo "⚙️ Validating CI configuration..."
npx circleci config validate
# or
# npx github-actions-validator .github/workflows/

# Docker build test
echo "🐳 Testing Docker build..."
docker build -t test-build . --target production

# Environment-specific builds
echo "🏗️ Testing environment builds..."
npm run build:staging
npm run build:production

# API contract validation
echo "📋 Validating API contracts..."
npx swagger-codegen validate openapi.yaml

echo "✅ CI/CD checks passed!"
```

## Specialized Hook Examples

### Security-focused Hooks
```bash
# .husky/pre-commit - Security focused
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🔐 Running security-focused checks..."

# Secrets detection
echo "🕵️ Scanning for secrets..."
npx detect-secrets scan --all-files

# Dependency security audit
echo "🛡️ Auditing dependencies..."
npm audit --audit-level moderate

# SAST (Static Application Security Testing)
echo "🔍 Running SAST scan..."
npx semgrep scan --config=security src/

# Check for hardcoded credentials
echo "🔑 Checking for hardcoded credentials..."
grep -r -i "password\|secret\|key\|token" src/ && exit 1

# Validate SSL certificates (if any)
echo "🔐 Validating SSL certificates..."
find . -name "*.pem" -o -name "*.crt" | xargs -I {} openssl x509 -in {} -text -noout

echo "✅ Security checks passed!"
```

### Performance-focused Hooks
```bash
# .husky/pre-commit - Performance focused
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "⚡ Running performance-focused checks..."

# Bundle size analysis
echo "📦 Analyzing bundle size..."
npm run build
npm run bundle-analyzer:check-size

# Performance regression tests
echo "🏃 Running performance tests..."
npm run test:performance

# Lighthouse CI (for web projects)
echo "🏠 Running Lighthouse CI..."
npx lhci autorun

# Memory leak detection
echo "🧠 Checking for memory leaks..."
npm run test:memory-leaks

# Code complexity analysis
echo "📊 Analyzing code complexity..."
npx complexity-report --format json src/

echo "✅ Performance checks passed!"
```

### Database Migration Hooks
```bash
# .husky/pre-commit - Database focused
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🗄️ Running database-focused checks..."

# Validate migration files
echo "📄 Validating migrations..."
npm run migrate:validate

# Check for dangerous operations
echo "⚠️ Checking for dangerous DB operations..."
grep -r "DROP TABLE\|DELETE FROM\|TRUNCATE" migrations/ && exit 1

# Schema validation
echo "📋 Validating database schema..."
npm run schema:validate

# Backup verification
echo "💾 Verifying backup procedures..."
npm run backup:test

echo "✅ Database checks passed!"
```

## Testing Integration

### Test-driven Development Hooks
```bash
# .husky/pre-commit - TDD focused
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🧪 Running TDD-focused checks..."

# Ensure tests exist for new code
echo "📝 Checking test coverage for new files..."
CHANGED_FILES=$(git diff --cached --name-only --diff-filter=A | grep -E '\.(js|ts|jsx|tsx)$')

for file in $CHANGED_FILES; do
  # Check if corresponding test file exists
  TEST_FILE="${file%.*}.test.${file##*.}"
  SPEC_FILE="${file%.*}.spec.${file##*.}"

  if [ ! -f "$TEST_FILE" ] && [ ! -f "$SPEC_FILE" ]; then
    echo "❌ No test file found for $file"
    echo "Please create $TEST_FILE or $SPEC_FILE"
    exit 1
  fi
done

# Run only tests for changed files
echo "🏃 Running tests for changed files..."
npm run test:changed

# Check test coverage thresholds
echo "📊 Checking test coverage..."
npm run test:coverage:check

echo "✅ TDD checks passed!"
```

### E2E Testing Hooks
```bash
# .husky/pre-push - E2E testing
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🎭 Running E2E testing checks..."

# Start test environment
echo "🚀 Starting test environment..."
npm run test:env:start

# Wait for services to be ready
echo "⏳ Waiting for services..."
npx wait-on http://localhost:3000

# Run E2E tests
echo "🎯 Running E2E tests..."
npm run test:e2e

# Cleanup test environment
echo "🧹 Cleaning up test environment..."
npm run test:env:stop

echo "✅ E2E tests passed!"
```

## IDE Integration

### VS Code Configuration
```json
// .vscode/settings.json
{
  "git.enableCommitSigning": true,
  "git.alwaysSignOff": true,
  "git.inputValidation": "always",
  "git.inputValidationLength": 72,
  "git.inputValidationSubjectLength": 50,
  "husky.enable": true,
  "terminal.integrated.env.osx": {
    "HUSKY_SKIP_HOOKS": "0"
  },
  "terminal.integrated.env.linux": {
    "HUSKY_SKIP_HOOKS": "0"
  },
  "terminal.integrated.env.windows": {
    "HUSKY_SKIP_HOOKS": "0"
  }
}

// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Skip Husky Hooks",
      "type": "shell",
      "command": "export HUSKY_SKIP_HOOKS=1",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always"
      }
    },
    {
      "label": "Enable Husky Hooks",
      "type": "shell",
      "command": "export HUSKY_SKIP_HOOKS=0",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always"
      }
    }
  ]
}
```

### Git Configuration Integration
```bash
# .gitconfig - Global Husky settings
[core]
    hooksPath = .husky

[commit]
    template = .gitmessage
    gpgsign = true

[push]
    default = simple
    followTags = true

[alias]
    # Commit with hooks
    cm = commit -m
    # Commit without hooks
    cmn = commit --no-verify -m
    # Push without hooks
    psn = push --no-verify
```

```
# .gitmessage - Commit message template
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>
#
# Types:
# feat: A new feature
# fix: A bug fix
# docs: Documentation only changes
# style: Changes that do not affect the meaning of the code
# refactor: A code change that neither fixes a bug nor adds a feature
# perf: A code change that improves performance
# test: Adding missing tests or correcting existing tests
# chore: Changes to the build process or auxiliary tools
```

## Troubleshooting

### Common Issues & Solutions

**Issue**: Hooks not executing
**Cause**: Hooks directory not in Git hooks path or not executable
**Solution**:
```bash
# Reinstall Husky
rm -rf .husky
npx husky install

# Make hooks executable
chmod +x .husky/*

# Check Git hooks path
git config core.hooksPath
```

**Issue**: Permission denied errors
**Cause**: Hook files don't have execute permissions
**Solution**:
```bash
# Fix permissions
chmod +x .husky/_/husky.sh
chmod +x .husky/*

# Verify permissions
ls -la .husky/
```

**Issue**: Hooks running in wrong directory
**Cause**: Working directory not set correctly
**Solution**:
```bash
# Add to beginning of hook file
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

cd "$(git rev-parse --show-toplevel)"
```

**Issue**: Environment variables not available
**Cause**: Shell environment differences
**Solution**:
```bash
# Source environment in hook
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# Load environment variables
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi
```

### Debug Mode
```bash
# Enable Husky debug mode
HUSKY_DEBUG=1 git commit -m "test"

# Check hook execution
echo "Debug: Hook starting" >> /tmp/husky-debug.log
echo "Debug: Working directory: $(pwd)" >> /tmp/husky-debug.log
echo "Debug: Git root: $(git rev-parse --show-toplevel)" >> /tmp/husky-debug.log
```

### Performance Optimization
```bash
# .husky/pre-commit - Optimized for performance
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# Early exit if no relevant files changed
CHANGED_FILES=$(git diff --cached --name-only)
if ! echo "$CHANGED_FILES" | grep -E '\.(js|jsx|ts|tsx|css|scss|json)$' > /dev/null; then
  echo "⏭️ No relevant files changed, skipping checks"
  exit 0
fi

# Run checks in parallel
{
  echo "🔍 Linting..."
  npx lint-staged
} &

{
  echo "🧪 Testing..."
  npm run test:quick
} &

# Wait for all background jobs
wait

echo "✅ All checks passed!"
```

## Best Practices

### Hook Organization
- Keep hooks simple and focused on single responsibilities
- Use external scripts for complex logic instead of inline commands
- Implement proper error handling and user feedback
- Make hooks fail fast to save developer time
- Use conditional execution to skip unnecessary work

### Performance Guidelines
- Run only necessary checks based on changed files
- Use parallel execution for independent checks
- Implement early exit strategies for irrelevant changes
- Cache results when possible
- Profile hook execution times and optimize bottlenecks

### Team Collaboration
- Document all hooks and their purposes in README
- Make hook skipping instructions clear for emergency situations
- Use consistent exit codes and error messages
- Implement gradual rollout for new hooks
- Provide troubleshooting guides for common issues

### Security Considerations
- Validate all input parameters in hooks
- Use secure methods for credential handling
- Implement proper logging for audit trails
- Restrict hook modifications to authorized team members
- Regular security reviews of hook implementations

## Useful Resources
- **Official Documentation**: https://typicode.github.io/husky/
- **Git Hooks Reference**: https://git-scm.com/docs/githooks
- **Conventional Commits**: https://www.conventionalcommits.org/
- **Commitlint**: https://commitlint.js.org/
- **Lint-staged**: https://github.com/okonet/lint-staged

## Tool-Specific Guidelines

### Version Compatibility
- **Node.js**: 18+ (20+ recommended)
- **Git**: 2.13+ (for core.hooksPath support)
- **npm**: 7+ (comes with Node.js 16+)

### Migration from Older Versions
```bash
# Migrate from Husky v4 to v9
npm uninstall husky
rm -rf .husky
npm install --save-dev husky@latest
npx husky init
npx husky add .husky/pre-commit "npm test"
```

### Integration Patterns
- Use with lint-staged for file-based operations
- Combine with commitlint for message validation
- Integrate with CI/CD pipelines for consistent quality gates
- Coordinate with IDE settings for seamless development experience
````
