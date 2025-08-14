````instructions
# Prettier Code Formatter Instructions

## Tool Overview
- **Tool Name**: Prettier
- **Version**: 3.0+ (stable), 3.3+ (latest with enhanced features)
- **Category**: Development Tools
- **Purpose**: Opinionated code formatter that enforces consistent style across codebases
- **Prerequisites**: Node.js 16+ (18+ recommended), npm/yarn/pnpm

## Installation & Setup
### Package Manager Installation
```bash
# npm installation
npm install --save-dev prettier
npm install -g prettier  # Global installation (not recommended)

# yarn installation
yarn add --dev prettier

# pnpm installation
pnpm add -D prettier

# Verify installation
npx prettier --version
```

### Project Integration
```bash
# Create configuration file
touch .prettierrc.json

# Create ignore file
touch .prettierignore

# Add to package.json scripts
{
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "format:diff": "prettier --list-different ."
  }
}

# Format specific files
npx prettier --write src/
npx prettier --write "**/*.{js,jsx,ts,tsx,json,css,md}"
```

### Basic Configuration (.prettierrc.json)
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "avoid",
  "endOfLine": "lf"
}
```

### Ignore Configuration (.prettierignore)
```
# Dependencies
node_modules/
.pnp/
.pnp.js

# Build outputs
build/
dist/
out/
.next/
.nuxt/

# Generated files
coverage/
*.min.js
*.min.css

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment files
.env.local
.env.development.local
.env.test.local
.env.production.local

# Package manager files
package-lock.json
yarn.lock
pnpm-lock.yaml

# IDE files
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db
```

## Core Features

### Automatic Code Formatting
- **Purpose**: Automatically format code to maintain consistent style
- **Usage**: Run Prettier on files to apply formatting rules
- **Example**:

**Before formatting:**
```javascript
const user={name:'John Doe',email:"john@example.com",age:30,roles:['admin','user'],preferences:{theme:'dark',notifications:true}};

function processUser(userData){
if(!userData){
return null;
}
const{name,email}=userData;
return{
formattedName:name.toUpperCase(),
emailDomain:email.split('@')[1]
};
}

const users=[
{id:1,name:'Alice',active:true},
{id:2,name:'Bob',active:false},
{id:3,name:'Charlie',active:true}
];
```

**After formatting:**
```javascript
const user = {
  name: 'John Doe',
  email: 'john@example.com',
  age: 30,
  roles: ['admin', 'user'],
  preferences: {
    theme: 'dark',
    notifications: true,
  },
};

function processUser(userData) {
  if (!userData) {
    return null;
  }
  const { name, email } = userData;
  return {
    formattedName: name.toUpperCase(),
    emailDomain: email.split('@')[1],
  };
}

const users = [
  { id: 1, name: 'Alice', active: true },
  { id: 2, name: 'Bob', active: false },
  { id: 3, name: 'Charlie', active: true },
];
```

### Multi-Language Support
- **Purpose**: Format various file types with consistent rules
- **Usage**: Configure language-specific options
- **Example**:

**JavaScript/TypeScript:**
```javascript
// Formatted JavaScript
const config = {
  apiUrl: process.env.API_URL || 'http://localhost:3000',
  timeout: 5000,
  retries: 3,
};

export async function fetchUserData(userId: number): Promise<User> {
  const response = await fetch(`${config.apiUrl}/users/${userId}`, {
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${getToken()}`,
    },
  });

  if (!response.ok) {
    throw new Error(`Failed to fetch user: ${response.statusText}`);
  }

  return response.json();
}
```

**CSS/SCSS:**
```css
/* Formatted CSS */
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 24px;
  margin-bottom: 16px;
  transition: transform 0.2s ease;
}

.card:hover {
  transform: translateY(-2px);
}
```

**HTML:**
```html
<!-- Formatted HTML -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Prettier Example</title>
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body>
    <div class="container">
      <header class="header">
        <h1>Welcome to Our App</h1>
        <nav class="navigation">
          <ul>
            <li><a href="/">Home</a></li>
            <li><a href="/about">About</a></li>
            <li><a href="/contact">Contact</a></li>
          </ul>
        </nav>
      </header>

      <main class="main-content">
        <section class="hero">
          <h2>Building Beautiful Applications</h2>
          <p>
            Experience the power of consistent code formatting with Prettier.
          </p>
          <button type="button" class="cta-button">Get Started</button>
        </section>
      </main>
    </div>
  </body>
</html>
```

**JSON:**
```json
{
  "name": "my-project",
  "version": "1.0.0",
  "description": "A sample project with Prettier configuration",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js",
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  },
  "dependencies": {
    "express": "^4.18.0",
    "cors": "^2.8.5",
    "helmet": "^7.0.0"
  },
  "devDependencies": {
    "prettier": "^3.3.0",
    "nodemon": "^3.0.0",
    "eslint": "^8.50.0"
  }
}
```

### Integration with Linters
- **Purpose**: Work alongside ESLint and other linters without conflicts
- **Usage**: Configure Prettier to handle formatting while linters handle code quality
- **Example**:
```bash
# Install ESLint-Prettier integration
npm install --save-dev eslint-config-prettier eslint-plugin-prettier
```

```json
// .eslintrc.json - ESLint + Prettier integration
{
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended",
    "prettier" // Turns off ESLint rules that conflict with Prettier
  ],
  "plugins": ["prettier"],
  "rules": {
    "prettier/prettier": "error",
    "no-console": "warn",
    "prefer-const": "error"
  }
}
```

## Common Commands
```bash
# Format files
prettier --write .                     # Format all files in project
prettier --write src/                  # Format specific directory
prettier --write "**/*.js"             # Format with glob pattern
prettier --write file.js               # Format single file

# Check formatting
prettier --check .                     # Check if files are formatted
prettier --list-different .           # List files that need formatting
prettier --check --error-on-unmatched-pattern  # Fail if no files match

# Output options
prettier --write --no-semi file.js     # Override config options
prettier --write --single-quote file.js # Use single quotes
prettier --write --tab-width 4 file.js  # Custom tab width

# Different output modes
prettier file.js                       # Output to stdout
prettier --write file.js               # Write to file
prettier --check file.js               # Check without formatting

# Configuration options
prettier --config .prettierrc.json --write .  # Use specific config
prettier --no-config --write .                # Ignore config files
prettier --config-precedence prefer-file      # Prefer file over CLI options

# Ignore patterns
prettier --write . --ignore-path .prettierignore   # Use ignore file
prettier --write . --ignore-pattern "dist/*"       # CLI ignore pattern

# Plugin usage
prettier --write . --plugin prettier-plugin-organize-imports
prettier --write . --plugin @prettier/plugin-php
```

## Advanced Features

### Configuration Options
```json
// .prettierrc.json - Comprehensive configuration
{
  // Basic formatting
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "quoteProps": "as-needed",
  "trailingComma": "es5",

  // Bracket and spacing
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "avoid",

  // Line endings and quotes
  "endOfLine": "lf",
  "singleAttributePerLine": false,

  // Language-specific overrides
  "overrides": [
    {
      "files": "*.json",
      "options": {
        "tabWidth": 2,
        "parser": "json"
      }
    },
    {
      "files": "*.md",
      "options": {
        "printWidth": 100,
        "proseWrap": "always"
      }
    },
    {
      "files": "*.css",
      "options": {
        "singleQuote": false
      }
    },
    {
      "files": "*.php",
      "options": {
        "phpVersion": "8.1",
        "braceStyle": "psr-2"
      }
    }
  ]
}
```

### Plugin System
```bash
# Install popular plugins
npm install --save-dev prettier-plugin-organize-imports
npm install --save-dev prettier-plugin-tailwindcss
npm install --save-dev @prettier/plugin-php
npm install --save-dev prettier-plugin-svelte
npm install --save-dev prettier-plugin-organize-attributes
```

```json
// .prettierrc.json - With plugins
{
  "plugins": [
    "prettier-plugin-organize-imports",
    "prettier-plugin-tailwindcss",
    "@prettier/plugin-php"
  ],
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80,

  // Plugin-specific options
  "organizeImportsSkipDestructiveCodeActions": true,
  "tailwindConfig": "./tailwind.config.js",
  "phpVersion": "8.1"
}
```

### File-specific Configuration
```javascript
// package.json - Prettier configuration
{
  "name": "my-project",
  "prettier": {
    "semi": false,
    "singleQuote": true,
    "tabWidth": 4
  }
}

// .prettierrc.js - Dynamic configuration
module.exports = {
  semi: true,
  singleQuote: true,
  tabWidth: process.env.NODE_ENV === 'development' ? 2 : 4,
  trailingComma: 'es5',
  overrides: [
    {
      files: '*.test.js',
      options: {
        semi: false,
      },
    },
    {
      files: ['*.yml', '*.yaml'],
      options: {
        tabWidth: 2,
      },
    },
  ],
};

// prettier.config.js - Alternative config file
export default {
  semi: true,
  singleQuote: true,
  trailingComma: 'all',
  printWidth: 120,
  tabWidth: 2,
};
```

## IDE Integration

### VS Code Setup
```json
// .vscode/settings.json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[markdown]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.wordWrap": "on",
    "editor.quickSuggestions": false
  },
  "prettier.requireConfig": true,
  "prettier.useEditorConfig": false
}

// .vscode/extensions.json
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "bradlc.vscode-tailwindcss"
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

// Alternative configuration
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx,json,css,scss,md,html,yml,yaml}": [
      "prettier --write",
      "git add"
    ]
  }
}
```

## Language-Specific Configurations

### React/JSX
```json
// .prettierrc.json - React optimized
{
  "semi": true,
  "singleQuote": true,
  "jsxSingleQuote": true,
  "trailingComma": "es5",
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "avoid",
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "jsxBracketSameLine": false
}
```

**Example React formatting:**
```jsx
// Before
const MyComponent=({title,items,onSelect,isLoading})=>{
return<div className="component-wrapper"><h1>{title}</h1>{isLoading?<div>Loading...</div>:<ul>{items.map(item=><li key={item.id} onClick={()=>onSelect(item)}>{item.name}</li>)}</ul>}</div>
}

// After
const MyComponent = ({ title, items, onSelect, isLoading }) => {
  return (
    <div className="component-wrapper">
      <h1>{title}</h1>
      {isLoading ? (
        <div>Loading...</div>
      ) : (
        <ul>
          {items.map(item => (
            <li key={item.id} onClick={() => onSelect(item)}>
              {item.name}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};
```

### TypeScript
```json
// .prettierrc.json - TypeScript specific
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100,
  "tabWidth": 2,
  "arrowParens": "avoid",
  "overrides": [
    {
      "files": "*.ts",
      "options": {
        "parser": "typescript"
      }
    }
  ]
}
```

**Example TypeScript formatting:**
```typescript
// Before
interface User{id:number;name:string;email:string;roles:Role[];preferences?:UserPreferences;}

type ApiResponse<T>=Promise<{data:T;error?:string;status:number;}>

class UserService{
private baseUrl:string;
constructor(baseUrl:string){this.baseUrl=baseUrl;}
async getUser(id:number):ApiResponse<User>{const response=await fetch(`${this.baseUrl}/users/${id}`);return response.json();}}

// After
interface User {
  id: number;
  name: string;
  email: string;
  roles: Role[];
  preferences?: UserPreferences;
}

type ApiResponse<T> = Promise<{
  data: T;
  error?: string;
  status: number;
}>;

class UserService {
  private baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  async getUser(id: number): ApiResponse<User> {
    const response = await fetch(`${this.baseUrl}/users/${id}`);
    return response.json();
  }
}
```

### CSS/SCSS
```json
// .prettierrc.json - CSS specific
{
  "overrides": [
    {
      "files": ["*.css", "*.scss", "*.less"],
      "options": {
        "singleQuote": false,
        "tabWidth": 2
      }
    }
  ]
}
```

**Example CSS formatting:**
```css
/* Before */
.container{display:flex;flex-direction:column;align-items:center;}.card{background:#ffffff;border:1px solid rgba(0,0,0,0.1);border-radius:8px;padding:16px 24px;margin:8px 0;box-shadow:0 2px 4px rgba(0,0,0,0.1);}.card:hover{transform:translateY(-2px);box-shadow:0 4px 8px rgba(0,0,0,0.15);}

/* After */
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.card {
  background: #ffffff;
  border: 1px solid rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  padding: 16px 24px;
  margin: 8px 0;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}
```

## CI/CD Integration

### GitHub Actions
```yaml
# .github/workflows/format-check.yml
name: Format Check

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  format-check:
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

    - name: Check Prettier formatting
      run: npm run format:check

    - name: Run Prettier (if check fails)
      if: failure()
      run: |
        npm run format
        git diff --exit-code || (echo "Files were reformatted. Please run 'npm run format' locally." && exit 1)

  auto-format:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'

    steps:
    - uses: actions/checkout@v4
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        ref: ${{ github.head_ref }}

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run Prettier
      run: npm run format

    - name: Commit changes
      run: |
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git add .
        git diff --staged --quiet || git commit -m "Auto-format with Prettier"
        git push
```

### Pre-push Hooks
```bash
# .husky/pre-push
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "Checking code formatting..."
npm run format:check

if [ $? -ne 0 ]; then
  echo "❌ Code formatting issues found. Run 'npm run format' to fix."
  exit 1
fi

echo "✅ Code formatting is correct."
```

## Team Workflow Integration

### Editor Configuration
```ini
# .editorconfig
root = true

[*]
charset = utf-8
end_of_line = lf
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false

[*.{yml,yaml}]
indent_size = 2

[*.json]
indent_size = 2

[Makefile]
indent_style = tab
```

### Documentation Integration
```markdown
<!-- README.md -->
# Project Setup

## Code Formatting

This project uses [Prettier](https://prettier.io/) for code formatting.

### Setup
```bash
npm install
npm run format
```

### Commands
- `npm run format` - Format all files
- `npm run format:check` - Check if files are formatted
- `npm run format:diff` - Show files that need formatting

### IDE Setup
Install the Prettier extension for your editor:
- VS Code: `esbenp.prettier-vscode`
- WebStorm: Built-in support
- Vim: `prettier/vim-prettier`

### Git Hooks
Pre-commit hooks will automatically format staged files.
To skip hooks (not recommended): `git commit --no-verify`
```

## Custom Formatting Rules

### Organization-specific Configuration
```json
// .prettierrc.json - Enterprise configuration
{
  "printWidth": 120,
  "tabWidth": 4,
  "useTabs": false,
  "semi": true,
  "singleQuote": false,
  "quoteProps": "consistent",
  "trailingComma": "all",
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "always",
  "endOfLine": "crlf",

  "overrides": [
    {
      "files": ["src/**/*.js", "src/**/*.ts"],
      "options": {
        "printWidth": 100,
        "singleQuote": true
      }
    },
    {
      "files": ["docs/**/*.md"],
      "options": {
        "printWidth": 80,
        "proseWrap": "always"
      }
    },
    {
      "files": ["*.json"],
      "options": {
        "tabWidth": 2
      }
    }
  ]
}
```

### Custom Ignore Patterns
```
# .prettierignore - Advanced ignore patterns

# Generated files
**/*.generated.*
**/*.min.*
**/dist/**
**/build/**
**/coverage/**

# Third-party code
**/vendor/**
**/node_modules/**
**/lib/**

# Configuration files
.env*
*.config.js
webpack.config.js
rollup.config.js

# Documentation
CHANGELOG.md
LICENSE

# Data files
**/*.csv
**/*.xml
**/*.sql

# Binary files
**/*.pdf
**/*.zip
**/*.tar.gz

# IDE and OS files
.vscode/
.idea/
*.swp
*.swo
.DS_Store
Thumbs.db

# Specific patterns
src/legacy/**
test/fixtures/**
public/assets/**
```

## Performance Optimization

### Large Codebase Strategies
```bash
# Format specific directories only
prettier --write "src/**/*.{js,ts,jsx,tsx}"

# Use ignore patterns for performance
prettier --write . --ignore-pattern "node_modules/**" --ignore-pattern "dist/**"

# Format only changed files
git diff --name-only --diff-filter=ACMRTUXB | grep -E '\.(js|ts|jsx|tsx|json|css|md)$' | xargs prettier --write

# Parallel processing (with GNU parallel)
find src -name "*.js" -o -name "*.ts" | parallel prettier --write {}
```

### Caching Strategies
```json
// package.json - Cache-aware scripts
{
  "scripts": {
    "format": "prettier --write . --cache",
    "format:check": "prettier --check . --cache",
    "format:clear-cache": "prettier --write . --cache --cache-strategy content"
  }
}
```

## Common Issues & Solutions

### Conflicting Rules
**Problem**: ESLint and Prettier rules conflict
**Solution**: Use eslint-config-prettier to disable conflicting rules
```bash
npm install --save-dev eslint-config-prettier
```

```json
// .eslintrc.json
{
  "extends": [
    "eslint:recommended",
    "prettier" // Must be last to override other configs
  ]
}
```

### Line Length Issues
**Problem**: Long lines not wrapping properly
**Solution**: Adjust printWidth and consider code structure
```json
{
  "printWidth": 100,
  "overrides": [
    {
      "files": "*.md",
      "options": {
        "printWidth": 80,
        "proseWrap": "always"
      }
    }
  ]
}
```

### Plugin Conflicts
**Problem**: Multiple plugins causing formatting issues
**Solution**: Order plugins carefully and check compatibility
```json
{
  "plugins": [
    "prettier-plugin-organize-imports", // Run first
    "prettier-plugin-tailwindcss"       // Run after imports
  ]
}
```

## Useful Resources
- **Official Documentation**: https://prettier.io/docs/
- **Configuration Options**: https://prettier.io/docs/en/options.html
- **Plugin List**: https://prettier.io/docs/en/plugins.html
- **Playground**: https://prettier.io/playground/
- **VS Code Extension**: https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode

## Tool-Specific Guidelines

### Best Practices
- Enable format-on-save in your IDE for immediate feedback
- Use pre-commit hooks to ensure consistent formatting
- Configure Prettier before ESLint to avoid conflicts
- Use overrides for language-specific formatting needs
- Keep configuration simple and leverage Prettier's defaults

### Performance Tips
- Use .prettierignore to exclude unnecessary files
- Enable caching for faster subsequent runs
- Format only changed files in large repositories
- Use specific glob patterns instead of formatting everything
- Consider using prettier-plugin-organize-imports for better performance

### Security Considerations
- Validate Prettier configuration files in CI/CD
- Use specific plugin versions to avoid supply chain attacks
- Review custom plugins before installation
- Limit file access patterns in ignore configurations
- Keep Prettier and plugins updated for security patches

## Version Compatibility
- **Node.js**: 16+ (18+ recommended)
- **npm**: 7+ (comes with Node.js 16+)
- **VS Code**: Latest version for best extension support

## Troubleshooting

### Debug Mode
```bash
# Check what files Prettier will process
prettier --list-different .

# Debug configuration
prettier --find-config-path src/file.js
prettier --config-precedence prefer-file

# Verbose output
prettier --write . --loglevel debug
```

### Common Error Messages
- **Error**: `No parser could be inferred for file`
  **Cause**: File extension not recognized
  **Solution**: Add parser to configuration or use --parser flag

- **Error**: `Cannot resolve plugin`
  **Cause**: Plugin not installed or incorrectly specified
  **Solution**: Install plugin or check plugin name in configuration

- **Error**: `Conflicting configurations`
  **Cause**: Multiple config files with different settings
  **Solution**: Use single config file or configure precedence properly
````
