````instructions
# Parcel Build Tool Instructions

## Tool Overview
- **Tool Name**: Parcel
- **Version**: 2.8+ (stable), 2.12+ (latest with enhanced features)
- **Category**: Build Tools
- **Purpose**: Zero-configuration web application bundler with blazing fast performance
- **Prerequisites**: Node.js 16+ (18+ recommended), npm/yarn/pnpm

## Installation & Setup
### Package Manager Installation
```bash
# npm installation
npm install --save-dev parcel

# yarn installation
yarn add --dev parcel

# pnpm installation
pnpm add -D parcel

# Global installation (not recommended for projects)
npm install -g parcel

# Create new project with Parcel
mkdir my-parcel-app
cd my-parcel-app
npm init -y
npm install --save-dev parcel

# Verify installation
npx parcel --version
```

### Project Integration
```bash
# Initialize project structure
mkdir src
touch src/index.html src/index.js src/style.css

# Basic package.json scripts
{
  "source": "src/index.html",
  "scripts": {
    "start": "parcel",
    "build": "parcel build",
    "preview": "parcel serve dist"
  },
  "devDependencies": {
    "parcel": "^2.12.0"
  }
}

# Alternative source specification
{
  "scripts": {
    "start": "parcel src/index.html",
    "build": "parcel build src/index.html"
  }
}
```

### Basic Project Setup
```html
<!-- src/index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Parcel App</title>
  <link rel="stylesheet" href="./style.css">
</head>
<body>
  <div id="app">
    <h1>Hello Parcel!</h1>
    <button id="btn">Click me</button>
  </div>
  <script type="module" src="./index.js"></script>
</body>
</html>
```

```javascript
// src/index.js
import './style.css'
import { greet } from './utils'

const button = document.getElementById('btn')
const app = document.getElementById('app')

button.addEventListener('click', () => {
  app.innerHTML += `<p>${greet('Parcel')}</p>`
})

// Hot Module Replacement
if (module.hot) {
  module.hot.accept('./utils', () => {
    console.log('Utils module updated!')
  })
}
```

```css
/* src/style.css */
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  margin: 0;
  padding: 20px;
  background: #f5f5f5;
}

#app {
  max-width: 600px;
  margin: 0 auto;
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

button {
  background: #007acc;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
}

button:hover {
  background: #005f99;
}
```

## Core Features

### Zero Configuration
- **Purpose**: Get started without complex configuration files
- **Usage**: Parcel automatically detects and processes files based on extensions
- **Example**:
```bash
# Just point to entry file - Parcel handles the rest
npx parcel src/index.html

# Supports multiple entry points
npx parcel src/index.html src/admin.html

# Watch mode (default in development)
npx parcel src/index.html --no-hmr

# Production build
npx parcel build src/index.html
```

### Built-in Asset Processing
- **Purpose**: Process various file types without additional configuration
- **Usage**: Import assets directly in your code
- **Example**:
```javascript
// JavaScript/TypeScript
import { helper } from './utils.js'
import config from './config.json'
import data from './data.yaml'

// CSS/SCSS/LESS
import './styles.css'
import './theme.scss'
import './layout.less'

// Images
import logo from './logo.png'
import icon from './icon.svg'

// Fonts
import './fonts/custom-font.woff2'

// Workers
import Worker from './worker.js'
const worker = new Worker()

// Usage examples
document.body.style.backgroundImage = `url(${logo})`
document.getElementById('icon').src = icon
```

### Hot Module Replacement (HMR)
- **Purpose**: Update modules in real-time without losing application state
- **Usage**: Automatic for most modules, manual for complex state
- **Example**:
```javascript
// src/counter.js
let count = 0

export function increment() {
  count++
  updateDisplay()
}

export function getCount() {
  return count
}

function updateDisplay() {
  document.getElementById('count').textContent = count
}

// Hot reload preservation
if (module.hot) {
  module.hot.accept(() => {
    console.log('Counter module updated!')
    updateDisplay() // Refresh display with preserved state
  })
}

// src/app.js
import { increment, getCount } from './counter'

// HMR will preserve the count value when counter.js updates
document.getElementById('btn').onclick = increment

// Preserve state during HMR
if (module.hot) {
  module.hot.accept('./counter', () => {
    // Re-import updated module
    import('./counter').then(({ getCount }) => {
      console.log('Current count preserved:', getCount())
    })
  })
}
```

## Common Commands
```bash
# Development server
parcel                                   # Serve source file (if defined in package.json)
parcel src/index.html                   # Serve specific entry file
parcel "src/**/*.html"                  # Serve multiple files
parcel --port 3000                      # Custom port
parcel --host 0.0.0.0                  # Bind to all interfaces
parcel --https                         # Enable HTTPS

# Production build
parcel build src/index.html             # Build for production
parcel build src/index.html --no-minify # Build without minification
parcel build --public-url ./           # Custom public URL
parcel build --dist-dir build          # Custom output directory

# Watch mode (development)
parcel watch src/index.html             # Watch without server
parcel --no-hmr                        # Disable hot module replacement
parcel --no-autoinstall                # Disable automatic dependency installation

# Validation and inspection
parcel --reporter @parcel/reporter-bundle-analyzer  # Bundle analysis
parcel build --detailed-report         # Detailed build report
parcel --log-level verbose             # Detailed logging

# Multiple targets
parcel build src/index.html src/admin.html  # Multiple entry points
parcel "src/pages/*.html"               # Glob patterns
```

## Advanced Features

### Configuration (.parcelrc)
```json
{
  "extends": "@parcel/config-default",
  "transformers": {
    "*.{js,mjs,jsm,jsx,es6,cjs,ts,tsx}": [
      "@parcel/transformer-js",
      "@parcel/transformer-react-refresh-wrap"
    ]
  },
  "resolvers": ["@parcel/resolver-default"],
  "bundlers": {
    "*.{js,mjs,jsm,jsx,es6,cjs,ts,tsx}": "@parcel/bundler-default"
  },
  "namers": ["@parcel/namer-default"],
  "runtimes": {
    "browser": ["@parcel/runtime-browser-hmr"],
    "node": ["@parcel/runtime-js"]
  },
  "packagers": {
    "*.html": "@parcel/packager-html",
    "*.{js,mjs,jsm,jsx,es6,cjs,ts,tsx}": "@parcel/packager-js",
    "*.{css,scss,sass,less,styl}": "@parcel/packager-css"
  },
  "optimizers": {
    "*.{js,mjs,jsm,jsx,es6,cjs,ts,tsx}": ["@parcel/optimizer-terser"],
    "*.{css,scss,sass,less,styl}": ["@parcel/optimizer-cssnano"],
    "*.{png,jpg,jpeg,gif,webp}": ["@parcel/optimizer-imagemin"]
  },
  "reporters": ["@parcel/reporter-dev-server"]
}
```

### TypeScript Support
```typescript
// src/main.ts
interface User {
  id: number
  name: string
  email: string
}

class UserManager {
  private users: User[] = []

  addUser(user: User): void {
    this.users.push(user)
    this.render()
  }

  private render(): void {
    const container = document.getElementById('users')
    if (!container) return

    container.innerHTML = this.users
      .map(user => `
        <div class="user">
          <h3>${user.name}</h3>
          <p>${user.email}</p>
        </div>
      `)
      .join('')
  }
}

// Auto-detected TypeScript compilation
const userManager = new UserManager()

document.getElementById('add-user')?.addEventListener('click', () => {
  userManager.addUser({
    id: Date.now(),
    name: 'John Doe',
    email: 'john@example.com'
  })
})
```

```json
// tsconfig.json (optional - Parcel uses defaults)
{
  "compilerOptions": {
    "target": "es2018",
    "module": "esnext",
    "lib": ["dom", "es2018"],
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "allowSyntheticDefaultImports": true,
    "jsx": "react-jsx"
  },
  "include": ["src/**/*"]
}
```

### React Support
```jsx
// src/App.jsx
import React, { useState } from 'react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)
  const [todos, setTodos] = useState([])
  const [inputValue, setInputValue] = useState('')

  const addTodo = () => {
    if (inputValue.trim()) {
      setTodos([...todos, { id: Date.now(), text: inputValue }])
      setInputValue('')
    }
  }

  return (
    <div className="app">
      <h1>Parcel + React</h1>

      <div className="counter">
        <p>Count: {count}</p>
        <button onClick={() => setCount(count + 1)}>
          Increment
        </button>
      </div>

      <div className="todos">
        <h2>Todo List</h2>
        <div className="todo-input">
          <input
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && addTodo()}
            placeholder="Add a todo..."
          />
          <button onClick={addTodo}>Add</button>
        </div>

        <ul>
          {todos.map(todo => (
            <li key={todo.id}>{todo.text}</li>
          ))}
        </ul>
      </div>
    </div>
  )
}

export default App
```

```jsx
// src/index.jsx
import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'

const container = document.getElementById('root')
const root = createRoot(container)
root.render(<App />)

// Hot Module Replacement for React
if (module.hot) {
  module.hot.accept('./App', () => {
    root.render(<App />)
  })
}
```

### Vue Support
```vue
<!-- src/App.vue -->
<template>
  <div class="app">
    <h1>{{ title }}</h1>

    <div class="counter">
      <p>Count: {{ count }}</p>
      <button @click="increment">Increment</button>
    </div>

    <div class="todo-list">
      <h2>Todos</h2>
      <form @submit.prevent="addTodo">
        <input v-model="newTodo" placeholder="Add a todo...">
        <button type="submit">Add</button>
      </form>

      <ul>
        <li v-for="todo in todos" :key="todo.id">
          {{ todo.text }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'

export default {
  name: 'App',
  setup() {
    const title = 'Parcel + Vue 3'
    const count = ref(0)
    const todos = ref([])
    const newTodo = ref('')

    const increment = () => {
      count.value++
    }

    const addTodo = () => {
      if (newTodo.value.trim()) {
        todos.value.push({
          id: Date.now(),
          text: newTodo.value
        })
        newTodo.value = ''
      }
    }

    return {
      title,
      count,
      todos,
      newTodo,
      increment,
      addTodo
    }
  }
}
</script>

<style scoped>
.app {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

.counter, .todo-list {
  margin: 20px 0;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
}

button {
  background: #42b883;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background: #369870;
}
</style>
```

### Sass/SCSS Support
```scss
// src/styles/variables.scss
$primary-color: #007acc;
$secondary-color: #42b883;
$font-size-base: 16px;
$border-radius: 8px;

// src/styles/mixins.scss
@mixin button-style($bg-color) {
  background: $bg-color;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: $border-radius;
  cursor: pointer;
  font-size: $font-size-base;
  transition: background-color 0.3s ease;

  &:hover {
    background: darken($bg-color, 10%);
  }
}

@mixin card {
  background: white;
  padding: 20px;
  border-radius: $border-radius;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin: 20px 0;
}

// src/styles/main.scss
@import './variables';
@import './mixins';

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  margin: 0;
  padding: 20px;
  background: #f5f5f5;
}

.app {
  max-width: 800px;
  margin: 0 auto;
}

.card {
  @include card;
}

.btn-primary {
  @include button-style($primary-color);
}

.btn-secondary {
  @include button-style($secondary-color);
}

// Responsive design
@media (max-width: 768px) {
  .app {
    padding: 10px;
  }

  .card {
    padding: 15px;
  }
}
```

## Build Optimization

### Code Splitting
```javascript
// Dynamic imports for code splitting
async function loadFeature() {
  const { default: FeatureComponent } = await import('./FeatureComponent')
  return FeatureComponent
}

// Route-based splitting
const routes = {
  '/': () => import('./pages/Home'),
  '/about': () => import('./pages/About'),
  '/contact': () => import('./pages/Contact')
}

function navigate(path) {
  routes[path]().then(({ default: Component }) => {
    // Render component
    new Component().render()
  })
}

// Vendor code splitting (automatic with Parcel)
import 'lodash' // Will be split into separate vendor bundle
import './main.css'

// Preload critical modules
const criticalModule = import(/* webpackPreload: true */ './critical-feature')
```

### Asset Optimization
```javascript
// Image optimization
import heroImage from './images/hero.jpg'
import thumbnail from './images/thumb.jpg?width=300&height=200'

// SVG handling
import logo from './logo.svg'
import iconSprite from './icons/*.svg' // Bundle multiple SVGs

// Font loading
import './fonts/custom-font.woff2'

// Service Worker
import { register } from './service-worker'

if ('serviceWorker' in navigator) {
  register()
}

// Lazy loading images
function lazyLoadImages() {
  const images = document.querySelectorAll('img[data-src]')

  const imageObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target
        img.src = img.dataset.src
        img.classList.remove('lazy')
        imageObserver.unobserve(img)
      }
    })
  })

  images.forEach(img => imageObserver.observe(img))
}
```

### Environment Variables
```javascript
// .env
NODE_ENV=development
API_URL=http://localhost:3000/api
ANALYTICS_ID=UA-123456789-1
FEATURE_FLAG_NEW_UI=true

// .env.production
NODE_ENV=production
API_URL=https://api.example.com
ANALYTICS_ID=UA-123456789-2
FEATURE_FLAG_NEW_UI=false

// src/config.js
export const config = {
  apiUrl: process.env.API_URL,
  analyticsId: process.env.ANALYTICS_ID,
  features: {
    newUI: process.env.FEATURE_FLAG_NEW_UI === 'true'
  },
  isDevelopment: process.env.NODE_ENV === 'development'
}

// Usage
import { config } from './config'

if (config.features.newUI) {
  import('./components/NewUI').then(({ default: NewUI }) => {
    new NewUI().render()
  })
}
```

## Testing Integration

### Jest Setup
```javascript
// package.json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  },
  "jest": {
    "testEnvironment": "jsdom",
    "moduleNameMapping": {
      "\\.(css|less|scss|sass)$": "identity-obj-proxy",
      "\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2)$": "<rootDir>/__mocks__/fileMock.js"
    },
    "setupFilesAfterEnv": ["<rootDir>/src/setupTests.js"]
  }
}

// __mocks__/fileMock.js
module.exports = 'test-file-stub'

// src/setupTests.js
import '@testing-library/jest-dom'

// src/components/Button.test.js
import { render, fireEvent, screen } from '@testing-library/react'
import Button from './Button'

test('renders button with text', () => {
  render(<Button>Click me</Button>)
  expect(screen.getByText('Click me')).toBeInTheDocument()
})

test('calls onClick when clicked', () => {
  const handleClick = jest.fn()
  render(<Button onClick={handleClick}>Click me</Button>)

  fireEvent.click(screen.getByText('Click me'))
  expect(handleClick).toHaveBeenCalledTimes(1)
})
```

### Cypress E2E Testing
```javascript
// cypress.config.js
import { defineConfig } from 'cypress'

export default defineConfig({
  e2e: {
    baseUrl: 'http://localhost:1234',
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
})

// cypress/e2e/app.cy.js
describe('Parcel App E2E', () => {
  beforeEach(() => {
    cy.visit('/')
  })

  it('should display the app title', () => {
    cy.contains('Hello Parcel!')
  })

  it('should handle user interactions', () => {
    cy.get('#btn').click()
    cy.contains('Hello from Parcel')
  })

  it('should navigate between pages', () => {
    cy.get('[data-testid="nav-about"]').click()
    cy.url().should('include', '/about')
  })
})

// package.json scripts
{
  "scripts": {
    "dev": "parcel src/index.html",
    "build": "parcel build src/index.html",
    "test:e2e": "cypress open",
    "test:e2e:headless": "cypress run"
  }
}
```

## Deployment Strategies

### Static Hosting
```bash
# Build for production
npm run build

# Deploy to Netlify
npm install -g netlify-cli
netlify deploy --prod --dir dist

# Deploy to Vercel
npm install -g vercel
vercel --prod

# Deploy to GitHub Pages
npm install -g gh-pages
gh-pages -d dist

# Deploy to AWS S3
aws s3 sync dist/ s3://your-bucket-name --delete

# Deploy to Firebase Hosting
npm install -g firebase-tools
firebase deploy
```

### CI/CD Pipeline
```yaml
# .github/workflows/deploy.yml
name: Build and Deploy
on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
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

    - name: Run tests
      run: npm test

    - name: Build application
      run: npm run build
      env:
        NODE_ENV: production
        API_URL: ${{ secrets.API_URL }}

    - name: Deploy to Netlify
      uses: netlify/actions/cli@master
      with:
        args: deploy --prod --dir=dist
      env:
        NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
        NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
```

## Common Issues & Solutions

### Build Performance
**Problem**: Slow build times with large applications
**Solution**: Optimize dependencies and use code splitting
```javascript
// Lazy load heavy dependencies
const heavyLibrary = await import('heavy-library')

// Use dynamic imports for conditional features
if (condition) {
  const { feature } = await import('./optional-feature')
}

// Optimize images
import optimizedImage from './image.jpg?width=800&format=webp'
```

### Memory Issues
**Problem**: Out of memory errors during builds
**Solution**: Increase Node.js memory limit
```bash
# Increase memory limit
NODE_OPTIONS="--max-old-space-size=4096" npm run build

# Or in package.json
{
  "scripts": {
    "build": "NODE_OPTIONS='--max-old-space-size=4096' parcel build src/index.html"
  }
}
```

### HMR Not Working
**Problem**: Hot Module Replacement stops working
**Solution**: Check for common HMR blockers
```javascript
// ❌ Avoid global side effects
window.myGlobal = 'value'

// ✅ Use module-scoped variables
let moduleState = 'value'

// ❌ Avoid unconditional event listeners
document.addEventListener('click', handler)

// ✅ Use conditional setup
if (!window.listenerAdded) {
  document.addEventListener('click', handler)
  window.listenerAdded = true
}
```

## Useful Resources
- **Official Documentation**: https://parceljs.org/
- **API Reference**: https://parceljs.org/plugin-browser-api/
- **Recipes**: https://parceljs.org/recipes/
- **Plugin Development**: https://parceljs.org/plugin-browser-api/
- **Community Plugins**: https://github.com/parcel-bundler/awesome-parcel

## Tool-Specific Guidelines

### Best Practices
- Use Parcel's zero-config approach - avoid premature optimization
- Leverage automatic code splitting for better performance
- Take advantage of built-in transformations (TypeScript, Sass, etc.)
- Use environment variables for configuration
- Implement proper error boundaries in React applications

### Performance Tips
- Enable tree shaking by using ES6 modules
- Use dynamic imports for code splitting
- Optimize images with query parameters
- Implement service workers for caching
- Use Parcel's built-in minification in production

### Security Considerations
- Sanitize environment variables before exposing to client
- Use HTTPS in production
- Implement Content Security Policy headers
- Validate all user inputs
- Keep dependencies updated

## Version Compatibility
- **Node.js**: 16+ (18+ recommended)
- **Browsers**: Modern browsers with ES2018+ support
- **npm**: 7+ (comes with Node.js 16+)

## Troubleshooting

### Debug Mode
```bash
# Enable verbose logging
PARCEL_LOGLEVEL=verbose parcel src/index.html

# Debug specific issues
PARCEL_LOGLEVEL=verbose parcel build src/index.html

# Check cache issues
rm -rf .parcel-cache node_modules/.cache
npm run build
```

### Common Error Messages
- **Error**: `Could not resolve dependency`
  **Cause**: Missing package or incorrect path
  **Solution**: Install package or fix import path

- **Error**: `Build failed due to optimization`
  **Cause**: Minification issues with specific code
  **Solution**: Check for unsupported syntax or disable minification temporarily

- **Error**: `Port already in use`
  **Cause**: Development server port conflict
  **Solution**: Use different port with `--port` flag
````
