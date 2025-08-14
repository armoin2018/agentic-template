````instructions
# Lint-staged Instructions

## Tool Overview
- **Tool Name**: lint-staged
- **Version**: 15.0+ (stable), 15.2+ (latest with enhanced performance)
- **Category**: Development Tools
- **Purpose**: Run linters on git staged files to ensure code quality before commits
- **Prerequisites**: Node.js 18+ (20+ recommended), Git 2.13+, npm/yarn/pnpm

## Installation & Setup
### Package Manager Installation
```bash
# npm installation
npm install --save-dev lint-staged
npm install -g lint-staged  # Global installation (not recommended)

# yarn installation
yarn add --dev lint-staged

# pnpm installation
pnpm add -D lint-staged

# Verify installation
npx lint-staged --version
```

### Project Integration
```bash
# Basic setup with Husky (recommended)
npm install --save-dev husky lint-staged

# Initialize Husky
npx husky init

# Add pre-commit hook
npx husky add .husky/pre-commit "npx lint-staged"

# Test the setup
npx lint-staged --debug
```

### Basic Configuration
```json
// package.json - Simple lint-staged setup
{
  "name": "my-project",
  "scripts": {
    "lint": "eslint src/",
    "format": "prettier --write .",
    "test": "jest"
  },
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,css,md}": [
      "prettier --write"
    ]
  },
  "devDependencies": {
    "husky": "^9.1.0",
    "lint-staged": "^15.2.0",
    "eslint": "^8.50.0",
    "prettier": "^3.0.0"
  }
}
```

### Advanced Configuration File
```javascript
// lint-staged.config.js - Advanced configuration
module.exports = {
  // JavaScript and TypeScript files
  '*.{js,jsx,ts,tsx}': [
    'eslint --fix',
    'prettier --write',
    'git add'
  ],

  // Style files
  '*.{css,scss,less}': [
    'stylelint --fix',
    'prettier --write'
  ],

  // JSON files
  '*.json': [
    'prettier --write'
  ],

  // Markdown files
  '*.md': [
    'markdownlint --fix',
    'prettier --write'
  ],

  // Package.json files
  'package.json': [
    'sort-package-json',
    'prettier --write'
  ],

  // Image optimization
  '*.{png,jpg,jpeg,gif,svg}': [
    'imagemin-lint-staged'
  ]
};
```

## Core Features

### File Pattern Matching
- **Purpose**: Apply different tools to different file types
- **Usage**: Use glob patterns to target specific files
- **Example**:

```json
{
  "lint-staged": {
    // Exact file extensions
    "*.js": "eslint --fix",
    "*.css": "stylelint --fix",

    // Multiple extensions
    "*.{js,jsx,ts,tsx}": ["eslint --fix", "prettier --write"],

    // Directory-specific patterns
    "src/**/*.{js,ts}": "eslint --fix",
    "tests/**/*.js": "jest --findRelatedTests",

    // Negation patterns
    "*.{js,ts}": "eslint --fix",
    "!dist/**": "echo 'Excluding dist files'",

    // Complex patterns
    "{src,lib}/**/*.{js,ts}": "eslint --fix",
    "*.{json,yml,yaml}": "prettier --write"
  }
}
```

### Command Execution
- **Purpose**: Run multiple commands on matched files
- **Usage**: Execute linters, formatters, and custom scripts
- **Example**:

```javascript
// Advanced command configuration
module.exports = {
  // Sequential execution
  '*.{js,jsx,ts,tsx}': [
    'eslint --fix',           // Fix linting issues first
    'prettier --write',       // Then format code
    'git add'                // Finally stage the changes
  ],

  // Conditional execution
  '*.js': (filenames) => [
    `eslint --fix ${filenames.join(' ')}`,
    `prettier --write ${filenames.join(' ')}`,
    `jest --findRelatedTests ${filenames.join(' ')}`
  ],

  // Custom functions
  '*.{png,jpg,jpeg}': (filenames) => {
    const compressed = filenames.map(f => `compressed/${f}`);
    return [
      `imagemin ${filenames.join(' ')} --out-dir=compressed/`,
      `git add ${compressed.join(' ')}`
    ];
  }
};
```

### Integration with Testing
- **Purpose**: Run tests related to changed files
- **Usage**: Execute targeted tests for better performance
- **Example**:

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write",
      "jest --findRelatedTests --passWithNoTests"
    ],
    "*.test.{js,ts}": [
      "jest --findRelatedTests"
    ],
    "src/**/*.{js,ts}": [
      "jest --findRelatedTests --coverage"
    ]
  }
}
```

**Advanced Testing Integration:**
```javascript
// lint-staged.config.js - Testing integration
const path = require('path');

module.exports = {
  // Component files
  'src/components/**/*.{js,jsx,ts,tsx}': [
    'eslint --fix',
    'prettier --write',
    'jest --findRelatedTests --passWithNoTests'
  ],

  // Utility functions
  'src/utils/**/*.{js,ts}': [
    'eslint --fix',
    'prettier --write',
    'jest --testPathPattern=utils --passWithNoTests'
  ],

  // API routes
  'src/api/**/*.{js,ts}': [
    'eslint --fix',
    'prettier --write',
    'jest --testPathPattern=api --passWithNoTests',
    'npm run test:integration'
  ],

  // Configuration files
  '*.config.{js,ts}': [
    'eslint --fix',
    'prettier --write',
    'npm run test:config'
  ]
};
```

## Language-Specific Configurations

### JavaScript/TypeScript Projects
```json
{
  "lint-staged": {
    "*.{js,jsx}": [
      "eslint --fix",
      "prettier --write",
      "jest --findRelatedTests --passWithNoTests"
    ],
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write",
      "tsc --noEmit",
      "jest --findRelatedTests --passWithNoTests"
    ],
    "*.d.ts": [
      "prettier --write"
    ]
  }
}
```

**Example with TypeScript validation:**
```javascript
// lint-staged.config.js - TypeScript focused
module.exports = {
  '*.{ts,tsx}': [
    'eslint --fix',
    'prettier --write',
    () => 'tsc --noEmit', // Type checking
    'jest --findRelatedTests --passWithNoTests'
  ],

  '*.js': [
    'eslint --fix',
    'prettier --write',
    'jest --findRelatedTests --passWithNoTests'
  ],

  // Type definition files
  '*.d.ts': [
    'prettier --write'
  ]
};
```

### React Projects
```json
{
  "lint-staged": {
    "src/**/*.{js,jsx,ts,tsx}": [
      "eslint --fix --ext .js,.jsx,.ts,.tsx",
      "prettier --write",
      "jest --findRelatedTests --passWithNoTests"
    ],
    "src/**/*.{css,scss}": [
      "stylelint --fix",
      "prettier --write"
    ],
    "public/**/*.html": [
      "prettier --write"
    ]
  }
}
```

**Advanced React configuration:**
```javascript
// lint-staged.config.js - React optimized
module.exports = {
  // Component files
  'src/components/**/*.{jsx,tsx}': [
    'eslint --fix --ext .jsx,.tsx',
    'prettier --write',
    'jest --findRelatedTests --passWithNoTests'
  ],

  // Hook files
  'src/hooks/**/*.{js,ts}': [
    'eslint --fix',
    'prettier --write',
    'jest --testPathPattern=hooks'
  ],

  // Style files
  'src/**/*.{css,scss,module.css}': [
    'stylelint --fix',
    'prettier --write'
  ],

  // Story files (Storybook)
  'src/**/*.stories.{js,jsx,ts,tsx}': [
    'eslint --fix',
    'prettier --write'
  ]
};
```

### Node.js/Express Projects
```json
{
  "lint-staged": {
    "src/**/*.{js,ts}": [
      "eslint --fix",
      "prettier --write",
      "jest --findRelatedTests --passWithNoTests"
    ],
    "routes/**/*.js": [
      "eslint --fix",
      "prettier --write",
      "npm run test:routes"
    ],
    "models/**/*.js": [
      "eslint --fix",
      "prettier --write",
      "npm run test:models"
    ],
    "package.json": [
      "sort-package-json",
      "prettier --write"
    ]
  }
}
```

### Python Projects (with Node.js tooling)
```json
{
  "lint-staged": {
    "*.py": [
      "black --check",
      "isort --check-only",
      "flake8",
      "mypy"
    ],
    "*.{js,ts}": [
      "eslint --fix",
      "prettier --write"
    ],
    "requirements*.txt": [
      "safety check -r"
    ]
  }
}
```

## Advanced Features

### Custom Command Functions
```javascript
// lint-staged.config.js - Custom functions
const path = require('path');

function eslintCommand(filenames) {
  return `eslint --fix ${filenames
    .map(f => path.relative(process.cwd(), f))
    .join(' ')}`;
}

function prettierCommand(filenames) {
  return `prettier --write ${filenames.join(' ')}`;
}

function jestCommand(filenames) {
  return `jest --findRelatedTests ${filenames.join(' ')} --passWithNoTests`;
}

module.exports = {
  '*.{js,jsx,ts,tsx}': [
    eslintCommand,
    prettierCommand,
    jestCommand
  ],

  // Dynamic command based on file count
  '*.css': (filenames) => {
    if (filenames.length > 10) {
      return 'stylelint --fix src/**/*.css';
    }
    return `stylelint --fix ${filenames.join(' ')}`;
  },

  // Conditional execution
  '*.{png,jpg,jpeg}': (filenames) => {
    const commands = [`imagemin ${filenames.join(' ')} --out-dir=optimized/`];

    // Only run if images are larger than 100KB
    const largeImages = filenames.filter(f => {
      const stats = require('fs').statSync(f);
      return stats.size > 100 * 1024;
    });

    if (largeImages.length > 0) {
      commands.push(`git add optimized/${largeImages.join(' optimized/')}`);
    }

    return commands;
  }
};
```

### Multi-stage Processing
```javascript
// lint-staged.config.js - Multi-stage processing
module.exports = {
  // Stage 1: Linting and formatting
  '*.{js,jsx,ts,tsx}': [
    'eslint --fix',
    'prettier --write'
  ],

  // Stage 2: Type checking (runs after formatting)
  '*.{ts,tsx}': [
    () => 'tsc --noEmit'
  ],

  // Stage 3: Testing (runs after type checking)
  '*.{js,jsx,ts,tsx}': [
    'jest --findRelatedTests --passWithNoTests'
  ],

  // Stage 4: Documentation generation
  'src/**/*.{js,ts}': [
    () => 'jsdoc -r src/ -d docs/'
  ]
};
```

### Performance Optimization
```javascript
// lint-staged.config.js - Performance optimized
const micromatch = require('micromatch');

module.exports = {
  // Optimize for large numbers of files
  '*.{js,jsx,ts,tsx}': (filenames) => {
    const jsFiles = micromatch(filenames, '*.{js,jsx}');
    const tsFiles = micromatch(filenames, '*.{ts,tsx}');

    const commands = [];

    if (jsFiles.length > 0) {
      commands.push(`eslint --fix ${jsFiles.join(' ')}`);
      commands.push(`prettier --write ${jsFiles.join(' ')}`);
    }

    if (tsFiles.length > 0) {
      commands.push(`eslint --fix ${tsFiles.join(' ')}`);
      commands.push(`prettier --write ${tsFiles.join(' ')}`);
      commands.push('tsc --noEmit');
    }

    // Run tests only if more than 5 files changed
    if (filenames.length <= 5) {
      commands.push(`jest --findRelatedTests ${filenames.join(' ')}`);
    } else {
      commands.push('npm run test:quick');
    }

    return commands;
  }
};
```

## Common Commands
```bash
# Run lint-staged manually
npx lint-staged                       # Run on all staged files
npx lint-staged --debug               # Run with debug output
npx lint-staged --verbose             # Run with verbose logging

# Configuration testing
npx lint-staged --dry-run             # Show what would be executed
npx lint-staged --diff                # Show diff of what changed

# Specific file patterns
npx lint-staged --filter="*.js"       # Run only on JS files
npx lint-staged --shell               # Use shell for command execution

# Integration commands
git add .                             # Stage files
npx lint-staged                      # Run linters on staged files
git commit -m "fix: update styles"   # Commit changes

# Troubleshooting
npx lint-staged --no-stash            # Don't stash unstaged changes
npx lint-staged --allow-empty         # Allow empty commits
```

## Integration Examples

### With Popular Tools
```json
{
  "lint-staged": {
    // ESLint integration
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix --max-warnings=0",
      "prettier --write"
    ],

    // Stylelint integration
    "*.{css,scss,less}": [
      "stylelint --fix",
      "prettier --write"
    ],

    // Markdownlint integration
    "*.md": [
      "markdownlint --fix",
      "prettier --write"
    ],

    // Package.json sorting
    "package.json": [
      "sort-package-json",
      "prettier --write"
    ],

    // Image optimization
    "*.{png,jpg,jpeg,gif}": [
      "imagemin-lint-staged"
    ],

    // SVG optimization
    "*.svg": [
      "svgo --multipass"
    ]
  }
}
```

### With Testing Frameworks
```javascript
// lint-staged.config.js - Testing framework integration
module.exports = {
  // Jest integration
  '*.{js,jsx,ts,tsx}': [
    'eslint --fix',
    'prettier --write',
    'jest --findRelatedTests --passWithNoTests --bail'
  ],

  // Vitest integration
  'src/**/*.{js,ts}': [
    'eslint --fix',
    'prettier --write',
    'vitest related --run'
  ],

  // Cypress component tests
  'src/components/**/*.{jsx,tsx}': [
    'eslint --fix',
    'prettier --write',
    'cypress run --component --spec'
  ],

  // Playwright tests
  'src/pages/**/*.{js,ts}': [
    'eslint --fix',
    'prettier --write',
    'playwright test --grep'
  ]
};
```

### With Build Tools
```json
{
  "lint-staged": {
    "src/**/*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write",
      "webpack --mode=development --bail"
    ],
    "src/**/*.{css,scss}": [
      "stylelint --fix",
      "prettier --write",
      "sass src/styles:dist/css --style=compressed"
    ],
    "*.{ts,tsx}": [
      "tsc --noEmit --skipLibCheck"
    ]
  }
}
```

## Monorepo Configuration

### Lerna/Nx Monorepo
```javascript
// lint-staged.config.js - Monorepo setup
const { execSync } = require('child_process');

function getChangedPackages(filenames) {
  const changedDirs = [...new Set(
    filenames.map(f => f.split('/')[1])
  )].filter(dir => dir !== undefined);

  return changedDirs;
}

module.exports = {
  'packages/*/src/**/*.{js,jsx,ts,tsx}': (filenames) => {
    const packages = getChangedPackages(filenames);

    return packages.flatMap(pkg => [
      `cd packages/${pkg} && npm run lint:fix`,
      `cd packages/${pkg} && npm run format`,
      `cd packages/${pkg} && npm test`
    ]);
  },

  'packages/*/package.json': [
    'sort-package-json',
    'prettier --write'
  ],

  // Root level files
  '*.{js,ts,json}': [
    'eslint --fix',
    'prettier --write'
  ]
};
```

### Yarn Workspaces
```javascript
// lint-staged.config.js - Yarn workspaces
module.exports = {
  'packages/*/src/**/*.{js,jsx,ts,tsx}': (filenames) => {
    const workspaces = [...new Set(
      filenames
        .filter(f => f.startsWith('packages/'))
        .map(f => f.split('/')[1])
    )];

    return workspaces.flatMap(workspace => [
      `yarn workspace ${workspace} lint:fix`,
      `yarn workspace ${workspace} format`,
      `yarn workspace ${workspace} test`
    ]);
  },

  // Shared configurations
  'shared/**/*.{js,ts}': [
    'eslint --fix',
    'prettier --write',
    'jest --findRelatedTests'
  ]
};
```

## CI/CD Integration

### GitHub Actions Integration
```yaml
# .github/workflows/lint-staged.yml
name: Lint Staged Files

on:
  pull_request:
    branches: [main, develop]

jobs:
  lint-staged:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Get changed files
      id: changed-files
      uses: tj-actions/changed-files@v40
      with:
        files: |
          *.{js,jsx,ts,tsx}
          *.{css,scss,less}
          *.{json,md}

    - name: Run lint-staged on changed files
      if: steps.changed-files.outputs.any_changed == 'true'
      run: |
        echo "${{ steps.changed-files.outputs.all_changed_files }}" | tr ' ' '\n' | xargs git add
        npx lint-staged
```

### Pre-commit Integration
```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: lint-staged
        name: lint-staged
        entry: npx lint-staged
        language: system
        pass_filenames: false
        always_run: true
```

## Performance Optimization

### Caching Strategies
```javascript
// lint-staged.config.js - With caching
const path = require('path');

module.exports = {
  '*.{js,jsx,ts,tsx}': [
    // Use ESLint cache
    'eslint --fix --cache --cache-location .eslintcache',
    'prettier --write',
    // Use Jest cache
    'jest --findRelatedTests --passWithNoTests --cache'
  ],

  '*.{css,scss}': [
    // Use Stylelint cache
    'stylelint --fix --cache --cache-location .stylelintcache',
    'prettier --write'
  ]
};
```

### Parallel Execution
```javascript
// lint-staged.config.js - Parallel execution
const { execSync } = require('child_process');

module.exports = {
  '*.{js,jsx,ts,tsx}': (filenames) => {
    // Split files into chunks for parallel processing
    const chunkSize = Math.ceil(filenames.length / 4);
    const chunks = [];

    for (let i = 0; i < filenames.length; i += chunkSize) {
      chunks.push(filenames.slice(i, i + chunkSize));
    }

    return chunks.map(chunk =>
      `eslint --fix ${chunk.join(' ')} && prettier --write ${chunk.join(' ')}`
    );
  }
};
```

## Troubleshooting

### Common Issues & Solutions

**Issue**: Commands not finding files
**Cause**: Incorrect glob patterns or working directory
**Solution**:
```javascript
// Use absolute paths
module.exports = {
  '*.js': (filenames) =>
    `eslint --fix ${filenames.map(f => path.resolve(f)).join(' ')}`
};
```

**Issue**: Git hooks not running lint-staged
**Cause**: Husky not properly configured
**Solution**:
```bash
# Reinstall Husky
rm -rf .husky
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"
```

**Issue**: Performance issues with large files
**Cause**: Running tools on too many files at once
**Solution**:
```javascript
module.exports = {
  '*.js': (filenames) => {
    if (filenames.length > 20) {
      return 'eslint --fix src/';
    }
    return `eslint --fix ${filenames.join(' ')}`;
  }
};
```

**Issue**: Commands failing silently
**Cause**: Missing error handling
**Solution**:
```javascript
module.exports = {
  '*.js': [
    'eslint --fix --max-warnings=0',  // Fail on warnings
    'prettier --check',               // Check formatting
    'jest --findRelatedTests --passWithNoTests --bail' // Fail fast
  ]
};
```

### Debug Configuration
```bash
# Debug lint-staged execution
DEBUG=lint-staged* npx lint-staged

# Test configuration without running
npx lint-staged --dry-run --verbose

# Check what files would be processed
git diff --staged --name-only | npx lint-staged --filter
```

## Best Practices

### Configuration Guidelines
- Use specific glob patterns to avoid unnecessary processing
- Order commands logically (lint → format → test)
- Include git add for tools that modify files
- Use functions for dynamic command generation
- Implement error handling and fail-fast strategies

### Performance Tips
- Enable caching for all tools that support it
- Use file filtering to run minimal necessary checks
- Implement parallel processing for large file sets
- Consider chunk size limits for command line arguments
- Profile execution times and optimize bottlenecks

### Team Collaboration
- Document all lint-staged configurations in README
- Use consistent patterns across all projects
- Implement gradual rollout for new configurations
- Provide troubleshooting guides for common issues
- Regular reviews of lint-staged performance and effectiveness

### Security Considerations
- Validate all file paths and commands
- Use specific tool versions to avoid supply chain attacks
- Implement proper error logging for audit trails
- Restrict configuration modifications to authorized team members
- Regular security reviews of custom command functions

## Useful Resources
- **Official Documentation**: https://github.com/okonet/lint-staged
- **Husky Integration**: https://typicode.github.io/husky/
- **Git Hooks**: https://git-scm.com/docs/githooks
- **Glob Patterns**: https://github.com/micromatch/micromatch
- **Performance Guide**: https://github.com/okonet/lint-staged#performance

## Tool-Specific Guidelines

### Version Compatibility
- **Node.js**: 18+ (20+ recommended)
- **Git**: 2.13+ (for modern hook support)
- **npm**: 7+ (comes with Node.js 16+)

### Integration Patterns
- Always use with Husky for git hook integration
- Combine with Prettier for consistent code formatting
- Integrate with ESLint for code quality enforcement
- Use with testing frameworks for quality gates
- Coordinate with CI/CD pipelines for complete coverage
````
