````instructions
# ESLint JavaScript Linter Instructions

## Tool Overview
- **Tool Name**: ESLint
- **Version**: 8.50+ (stable), 9.0+ (latest with flat config)
- **Category**: Development Tools
- **Purpose**: Pluggable JavaScript and TypeScript linter for identifying and fixing code quality issues
- **Prerequisites**: Node.js 16+ (18+ recommended), npm/yarn/pnpm

## Installation & Setup
### Package Manager Installation
```bash
# npm installation
npm install --save-dev eslint
npm install -g eslint  # Global installation (not recommended)

# yarn installation
yarn add --dev eslint

# pnpm installation
pnpm add -D eslint

# Initialize ESLint configuration
npx eslint --init

# Verify installation
npx eslint --version
```

### Project Integration
```bash
# Initialize ESLint in existing project
npx eslint --init

# This will ask questions and create .eslintrc.* file:
# - How would you like to use ESLint?
# - What type of modules does your project use?
# - Which framework does your project use?
# - Does your project use TypeScript?
# - Where does your code run?
# - How would you like to define a style for your project?

# Manual setup with basic config
touch .eslintrc.json

# Add to package.json scripts
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "lint:check": "eslint . --max-warnings 0"
  }
}
```

### Basic Configuration (.eslintrc.json)
```json
{
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": [
    "eslint:recommended"
  ],
  "parserOptions": {
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "rules": {
    "indent": ["error", 2],
    "linebreak-style": ["error", "unix"],
    "quotes": ["error", "single"],
    "semi": ["error", "always"]
  }
}
```

## Core Features

### Code Quality Rules
- **Purpose**: Enforce coding standards and catch potential bugs
- **Usage**: Configure rules to match your team's coding style
- **Example**:
```json
// .eslintrc.json - Code quality rules
{
  "extends": ["eslint:recommended"],
  "rules": {
    // Possible Errors
    "no-console": "warn",
    "no-debugger": "error",
    "no-dupe-args": "error",
    "no-dupe-keys": "error",
    "no-duplicate-case": "error",
    "no-empty": "error",
    "no-extra-semi": "error",
    "no-unreachable": "error",
    "no-unused-vars": "error",

    // Best Practices
    "curly": "error",
    "eqeqeq": ["error", "always"],
    "no-eval": "error",
    "no-implied-eval": "error",
    "no-global-assign": "error",
    "no-magic-numbers": ["warn", { "ignore": [0, 1, -1] }],
    "no-multi-spaces": "error",
    "no-redeclare": "error",
    "no-return-assign": "error",
    "no-unused-expressions": "error",
    "no-useless-return": "error",

    // Stylistic Issues
    "array-bracket-spacing": ["error", "never"],
    "block-spacing": "error",
    "brace-style": ["error", "1tbs"],
    "comma-dangle": ["error", "never"],
    "comma-spacing": ["error", { "before": false, "after": true }],
    "indent": ["error", 2],
    "key-spacing": ["error", { "beforeColon": false, "afterColon": true }],
    "max-len": ["error", { "code": 120 }],
    "no-mixed-spaces-and-tabs": "error",
    "no-trailing-spaces": "error",
    "quotes": ["error", "single"],
    "semi": ["error", "always"],
    "space-before-blocks": "error",
    "space-infix-ops": "error"
  }
}
```

### TypeScript Support
- **Purpose**: Lint TypeScript files with type-aware rules
- **Usage**: Use @typescript-eslint parser and rules
- **Example**:
```bash
# Install TypeScript ESLint packages
npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin

# TypeScript configuration
```

```json
// .eslintrc.json - TypeScript configuration
{
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 12,
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "plugins": [
    "@typescript-eslint"
  ],
  "rules": {
    // TypeScript specific rules
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-non-null-assertion": "error",
    "@typescript-eslint/prefer-const": "error",
    "@typescript-eslint/no-var-requires": "error",

    // Type-aware rules
    "@typescript-eslint/await-thenable": "error",
    "@typescript-eslint/no-floating-promises": "error",
    "@typescript-eslint/no-misused-promises": "error",
    "@typescript-eslint/prefer-nullish-coalescing": "error",
    "@typescript-eslint/prefer-optional-chain": "error",

    // Override JavaScript rules with TypeScript versions
    "no-unused-vars": "off",
    "@typescript-eslint/no-unused-vars": "error",
    "no-shadow": "off",
    "@typescript-eslint/no-shadow": "error"
  },
  "overrides": [
    {
      "files": ["*.js"],
      "rules": {
        "@typescript-eslint/explicit-function-return-type": "off"
      }
    }
  ]
}
```

### React/JSX Support
- **Purpose**: Lint React components and JSX syntax
- **Usage**: Use eslint-plugin-react for React-specific rules
- **Example**:
```bash
# Install React ESLint packages
npm install --save-dev eslint-plugin-react eslint-plugin-react-hooks
```

```json
// .eslintrc.json - React configuration
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended"
  ],
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "plugins": [
    "react",
    "react-hooks"
  ],
  "rules": {
    // React specific rules
    "react/prop-types": "error",
    "react/jsx-uses-react": "error",
    "react/jsx-uses-vars": "error",
    "react/jsx-key": "error",
    "react/jsx-no-duplicate-props": "error",
    "react/jsx-no-undef": "error",
    "react/jsx-pascal-case": "error",
    "react/no-danger": "warn",
    "react/no-deprecated": "error",
    "react/no-direct-mutation-state": "error",
    "react/no-unused-state": "error",
    "react/self-closing-comp": "error",

    // React Hooks rules
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn",

    // JSX formatting
    "react/jsx-indent": ["error", 2],
    "react/jsx-indent-props": ["error", 2],
    "react/jsx-max-props-per-line": ["error", { "maximum": 3 }],
    "react/jsx-closing-bracket-location": "error",
    "react/jsx-tag-spacing": "error"
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  }
}
```

## Common Commands
```bash
# Basic linting
eslint file.js                         # Lint single file
eslint src/                            # Lint directory
eslint "src/**/*.{js,jsx,ts,tsx}"      # Lint with glob pattern
eslint . --ext .js,.jsx,.ts,.tsx       # Lint with extensions

# Fix automatically fixable issues
eslint src/ --fix                      # Fix all fixable issues
eslint file.js --fix-dry-run           # Preview fixes without applying

# Output formats
eslint src/ --format compact           # Compact output
eslint src/ --format json              # JSON output
eslint src/ --format html              # HTML report
eslint src/ --format table             # Table format

# Configuration and debugging
eslint --print-config file.js          # Show computed config for file
eslint --debug                         # Debug mode with detailed output
eslint --max-warnings 0                # Treat warnings as errors

# Specific rule control
eslint src/ --rule 'quotes: [2, double]'  # Override specific rule
eslint src/ --no-eslintrc --config .eslintrc.prod.json  # Use specific config

# Cache for performance
eslint src/ --cache                    # Use cache for faster subsequent runs
eslint src/ --cache-location .eslintcache  # Custom cache location

# Ignore patterns
eslint src/ --ignore-path .eslintignore    # Use custom ignore file
eslint src/ --ignore-pattern "dist/*"     # Ignore pattern via CLI
```

## Advanced Features

### Custom Rules and Plugins
```javascript
// Custom rule example
// rules/no-console-warn.js
module.exports = {
  meta: {
    type: 'problem',
    docs: {
      description: 'disallow console.warn',
      category: 'Best Practices',
      recommended: false
    },
    fixable: null,
    schema: []
  },

  create(context) {
    return {
      MemberExpression(node) {
        if (node.object.name === 'console' && node.property.name === 'warn') {
          context.report({
            node,
            message: 'console.warn is not allowed'
          });
        }
      }
    };
  }
};

// Using custom rule in .eslintrc.json
{
  "plugins": ["./rules"],
  "rules": {
    "local/no-console-warn": "error"
  }
}
```

### Environment-Specific Configurations
```json
// .eslintrc.json - Multiple environments
{
  "root": true,
  "env": {
    "browser": true,
    "node": true,
    "es2021": true
  },
  "extends": ["eslint:recommended"],
  "overrides": [
    {
      "files": ["src/**/*.js"],
      "env": {
        "browser": true,
        "node": false
      },
      "rules": {
        "no-console": "error"
      }
    },
    {
      "files": ["scripts/**/*.js", "*.config.js"],
      "env": {
        "node": true,
        "browser": false
      },
      "rules": {
        "no-console": "off"
      }
    },
    {
      "files": ["**/*.test.js", "**/*.spec.js"],
      "env": {
        "jest": true
      },
      "rules": {
        "no-magic-numbers": "off"
      }
    }
  ]
}
```

### Flat Config (ESLint 9.0+)
```javascript
// eslint.config.js - New flat config format
import js from '@eslint/js';
import typescript from '@typescript-eslint/eslint-plugin';
import tsParser from '@typescript-eslint/parser';

export default [
  js.configs.recommended,
  {
    files: ['**/*.{js,mjs,cjs,ts,tsx}'],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaVersion: 2022,
        sourceType: 'module',
      },
    },
    plugins: {
      '@typescript-eslint': typescript,
    },
    rules: {
      'no-console': 'warn',
      'no-unused-vars': 'error',
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/explicit-function-return-type': 'error',
    },
  },
  {
    files: ['**/*.test.{js,ts}'],
    rules: {
      'no-magic-numbers': 'off',
    },
  },
  {
    ignores: ['dist/**', 'node_modules/**', 'build/**'],
  },
];
```

### Integration with Prettier
```bash
# Install Prettier integration
npm install --save-dev prettier eslint-config-prettier eslint-plugin-prettier
```

```json
// .eslintrc.json - Prettier integration
{
  "extends": [
    "eslint:recommended",
    "prettier" // Turns off ESLint rules that conflict with Prettier
  ],
  "plugins": ["prettier"],
  "rules": {
    "prettier/prettier": "error"
  }
}

// .prettierrc.json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
```

## IDE Integration

### VS Code Setup
```json
// .vscode/settings.json
{
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
  "eslint.workingDirectories": ["src"],
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "editor.formatOnSave": true,
  "eslint.format.enable": true,
  "[javascript]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint"
  },
  "[typescript]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint"
  }
}

// .vscode/extensions.json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode"
  ]
}
```

### Pre-commit Hooks
```bash
# Install husky and lint-staged
npm install --save-dev husky lint-staged

# Setup husky
npx husky install

# Add pre-commit hook
npx husky add .husky/pre-commit "npx lint-staged"
```

```json
// package.json - lint-staged configuration
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write",
      "git add"
    ],
    "*.{json,css,md}": [
      "prettier --write",
      "git add"
    ]
  }
}
```

## Configuration Examples

### Comprehensive Configuration
```json
// .eslintrc.json - Production-ready configuration
{
  "root": true,
  "env": {
    "browser": true,
    "node": true,
    "es2022": true
  },
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:import/recommended",
    "plugin:import/typescript",
    "prettier"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true
    },
    "project": "./tsconfig.json"
  },
  "plugins": [
    "@typescript-eslint",
    "react",
    "react-hooks",
    "import",
    "prettier"
  ],
  "settings": {
    "react": {
      "version": "detect"
    },
    "import/resolver": {
      "typescript": {
        "alwaysTryTypes": true
      }
    }
  },
  "rules": {
    // General
    "no-console": "warn",
    "no-debugger": "error",
    "no-alert": "error",
    "prefer-const": "error",
    "no-var": "error",

    // TypeScript
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/prefer-nullish-coalescing": "error",
    "@typescript-eslint/prefer-optional-chain": "error",

    // React
    "react/prop-types": "off", // Using TypeScript
    "react/react-in-jsx-scope": "off", // React 17+
    "react/jsx-uses-react": "off", // React 17+
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn",

    // Import
    "import/order": [
      "error",
      {
        "groups": [
          "builtin",
          "external",
          "internal",
          "parent",
          "sibling",
          "index"
        ],
        "newlines-between": "always"
      }
    ],
    "import/no-unresolved": "error",
    "import/no-unused-modules": "warn",

    // Prettier
    "prettier/prettier": "error"
  },
  "overrides": [
    {
      "files": ["**/*.test.{js,jsx,ts,tsx}"],
      "env": {
        "jest": true
      },
      "rules": {
        "@typescript-eslint/no-explicit-any": "off",
        "no-magic-numbers": "off"
      }
    },
    {
      "files": ["*.config.{js,ts}", "scripts/**"],
      "env": {
        "node": true
      },
      "rules": {
        "no-console": "off",
        "@typescript-eslint/no-var-requires": "off"
      }
    }
  ],
  "ignorePatterns": [
    "dist/",
    "build/",
    "node_modules/",
    "*.min.js",
    "coverage/"
  ]
}
```

### Monorepo Configuration
```json
// packages/shared/.eslintrc.json
{
  "extends": ["../../.eslintrc.json"],
  "env": {
    "browser": false,
    "node": true
  },
  "rules": {
    "no-console": "off"
  }
}

// packages/frontend/.eslintrc.json
{
  "extends": ["../../.eslintrc.json"],
  "env": {
    "browser": true,
    "node": false
  },
  "rules": {
    "no-console": "error"
  }
}

// Root .eslintrc.json
{
  "root": true,
  "extends": ["eslint:recommended"],
  "ignorePatterns": ["packages/*/dist/", "packages/*/build/"]
}
```

## CI/CD Integration

### GitHub Actions
```yaml
# .github/workflows/lint.yml
name: Lint

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run ESLint
      run: npm run lint

    - name: Run ESLint with JSON output
      run: npx eslint . --format json --output-file eslint-report.json
      continue-on-error: true

    - name: Upload ESLint report
      uses: actions/upload-artifact@v3
      with:
        name: eslint-report
        path: eslint-report.json
```

### Pre-commit Configuration
```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: eslint
        name: eslint
        entry: npx eslint --fix
        language: node
        types: [javascript]
        require_serial: false
        additional_dependencies: []
        minimum_pre_commit_version: 0.15.0
```

## Performance Optimization

### Caching
```bash
# Enable caching for faster subsequent runs
npx eslint . --cache

# Custom cache location
npx eslint . --cache --cache-location .eslintcache

# Cache strategy in CI
export ESLINT_USE_FLAT_CONFIG=false
npx eslint . --cache --cache-strategy content
```

### Parallel Processing
```json
// package.json - Parallel linting
{
  "scripts": {
    "lint": "eslint .",
    "lint:parallel": "eslint-parallel .",
    "lint:fix": "eslint . --fix",
    "lint:check": "eslint . --max-warnings 0"
  }
}
```

## Common Issues & Solutions

### Performance Issues
**Problem**: ESLint runs slowly on large codebases
**Solution**: Use caching and optimize configuration
```json
{
  "parserOptions": {
    "project": "./tsconfig.json" // Only include necessary files
  },
  "ignorePatterns": [
    "node_modules/",
    "dist/",
    "build/",
    "coverage/"
  ]
}
```

### Configuration Conflicts
**Problem**: Rules conflict between different extends
**Solution**: Order extends properly and override conflicting rules
```json
{
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended",
    "prettier" // Put prettier last to override conflicting rules
  ],
  "rules": {
    // Override specific conflicting rules
    "@typescript-eslint/indent": "off",
    "indent": "off"
  }
}
```

### TypeScript Project Issues
**Problem**: Cannot resolve TypeScript paths or slow parsing
**Solution**: Optimize TypeScript configuration
```json
// tsconfig.eslint.json - Separate config for ESLint
{
  "extends": "./tsconfig.json",
  "include": [
    "src/**/*",
    "test/**/*",
    "*.js",
    "*.ts"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "build"
  ]
}

// .eslintrc.json
{
  "parserOptions": {
    "project": "./tsconfig.eslint.json"
  }
}
```

## Useful Resources
- **Official Documentation**: https://eslint.org/docs/
- **Rules Reference**: https://eslint.org/docs/rules/
- **Configuration Guide**: https://eslint.org/docs/user-guide/configuring
- **Plugin Development**: https://eslint.org/docs/developer-guide/working-with-plugins
- **Awesome ESLint**: https://github.com/dustinspecker/awesome-eslint

## Tool-Specific Guidelines

### Best Practices
- Start with recommended configurations and customize gradually
- Use extends to share configurations across projects
- Organize rules logically with comments
- Use overrides for different file types or environments
- Implement gradual adoption for legacy codebases

### Performance Tips
- Use caching in development and CI environments
- Limit TypeScript project scope to necessary files
- Use ignore patterns to exclude unnecessary files
- Consider using eslint-parallel for large codebases
- Profile performance with --debug flag

### Security Considerations
- Use eslint-plugin-security for security-focused rules
- Avoid eval and other dangerous patterns
- Validate configuration files in CI/CD
- Keep dependencies updated for security patches
- Use proper ignore patterns to avoid linting sensitive files

## Version Compatibility
- **Node.js**: 16+ (18+ recommended)
- **npm**: 7+ (comes with Node.js 16+)
- **TypeScript**: 4.7+ (5.0+ recommended)

## Troubleshooting

### Debug Mode
```bash
# Enable debug output
npx eslint --debug src/

# Print configuration for specific file
npx eslint --print-config src/file.js

# Check what files are being linted
npx eslint --debug 2>&1 | grep "Processing"
```

### Common Error Messages
- **Error**: `Parsing error: Cannot read file`
  **Cause**: TypeScript configuration issues
  **Solution**: Check tsconfig.json path and includes

- **Error**: `Definition for rule 'rule-name' was not found`
  **Cause**: Missing plugin or incorrect rule name
  **Solution**: Install required plugin or check rule name

- **Error**: `Failed to load config "config-name"`
  **Cause**: Missing shareable config package
  **Solution**: Install the required config package
````
