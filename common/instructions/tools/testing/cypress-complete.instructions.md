````instructions
# Cypress End-to-End Testing Framework Instructions

## Tool Overview
- **Tool Name**: Cypress
- **Version**: 13.6+ (stable), 13.7+ (latest with enhanced features)
- **Category**: Testing Tools
- **Purpose**: Modern end-to-end testing framework for web applications with time-travel debugging
- **Prerequisites**: Node.js 18+ (16+ minimum), npm/yarn/pnpm

## Installation & Setup
### Installation Methods
```bash
# npm installation
npm install --save-dev cypress
npx cypress open  # Open Cypress Test Runner

# yarn installation
yarn add --dev cypress
yarn cypress open

# pnpm installation
pnpm add -D cypress
pnpm cypress open

# Global installation (not recommended)
npm install -g cypress

# Verify installation
npx cypress verify
npx cypress version
```

### Project Initialization
```bash
# Initialize Cypress in existing project
npx cypress open

# This creates:
# - cypress/ directory with example tests
# - cypress.config.js configuration file
# - cypress/fixtures/ for test data
# - cypress/support/ for commands and setup

# Basic project structure
my-project/
├── cypress.config.js
├── cypress/
│   ├── e2e/
│   │   └── spec.cy.js
│   ├── fixtures/
│   │   └── example.json
│   └── support/
│       ├── commands.js
│       └── e2e.js
└── node_modules/
```

### Installation with TypeScript
```bash
# Install TypeScript support
npm install --save-dev typescript

# Create tsconfig.json in cypress directory
# cypress/tsconfig.json
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["es5", "dom"],
    "types": ["cypress", "node"]
  },
  "include": ["**/*.ts"]
}
```

## Configuration

### Basic Configuration (cypress.config.js)
```javascript
const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    // Base URL for your application
    baseUrl: 'http://localhost:3000',

    // Viewport settings
    viewportWidth: 1280,
    viewportHeight: 720,

    // Test files
    specPattern: 'cypress/e2e/**/*.cy.{js,jsx,ts,tsx}',

    // Support files
    supportFile: 'cypress/support/e2e.js',

    // Fixtures
    fixturesFolder: 'cypress/fixtures',

    // Screenshots and videos
    screenshotsFolder: 'cypress/screenshots',
    videosFolder: 'cypress/videos',
    video: true,
    screenshotOnRunFailure: true,

    // Browser settings
    chromeWebSecurity: false,

    // Test execution
    testIsolation: true,
    experimentalRunAllSpecs: true,

    // Timeouts
    defaultCommandTimeout: 4000,
    requestTimeout: 5000,
    responseTimeout: 30000,
    pageLoadTimeout: 60000,

    // Retry settings
    retries: {
      runMode: 2,
      openMode: 0
    },

    // Setup function
    setupNodeEvents(on, config) {
      // implement node event listeners here
    }
  },

  component: {
    devServer: {
      framework: 'react',
      bundler: 'webpack'
    }
  }
})
```

### Advanced Configuration
```javascript
const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:3000',

    // Environment-specific settings
    env: {
      apiUrl: 'http://localhost:8000/api',
      adminUser: 'admin@example.com',
      adminPassword: 'password123'
    },

    // Multiple environments
    // Override with: cypress run --env environment=staging
    ...(process.env.CYPRESS_ENV === 'staging' && {
      baseUrl: 'https://staging.example.com',
      env: {
        apiUrl: 'https://staging-api.example.com'
      }
    }),

    // Custom user agent
    userAgent: 'Custom Cypress Test Agent',

    // Network settings
    blockHosts: ['google-analytics.com', 'hotjar.com'],
    modifyObstructiveCode: false,

    // Security settings
    chromeWebSecurity: false,
    experimentalModifyObstructiveThirdPartyCode: true,

    // File settings
    downloadsFolder: 'cypress/downloads',
    fileServerFolder: 'cypress',

    // Test configuration
    includeShadowDom: true,
    experimentalStudio: true,
    experimentalWebKitSupport: true,

    // Node events setup
    setupNodeEvents(on, config) {
      // Task registration
      on('task', {
        log(message) {
          console.log(message)
          return null
        },

        // Database seeding
        seedDatabase() {
          // Database seeding logic
          return null
        },

        // File operations
        readFileMaybe(filename) {
          if (fs.existsSync(filename)) {
            return fs.readFileSync(filename, 'utf8')
          }
          return null
        }
      })

      // Plugin registration
      require('cypress-terminal-report/src/installLogsPrinter')(on)

      // Environment configuration
      if (config.env.environment === 'ci') {
        config.baseUrl = 'https://ci.example.com'
      }

      return config
    }
  }
})
```

### TypeScript Configuration
```javascript
// cypress.config.ts
import { defineConfig } from 'cypress'

export default defineConfig({
  e2e: {
    baseUrl: 'http://localhost:3000',
    specPattern: 'cypress/e2e/**/*.cy.{js,ts}',
    supportFile: 'cypress/support/e2e.ts',

    setupNodeEvents(on, config) {
      // TypeScript preprocessing
      on('file:preprocessor', require('@cypress/webpack-preprocessor')({
        webpackOptions: {
          resolve: {
            extensions: ['.ts', '.js']
          },
          module: {
            rules: [
              {
                test: /\.ts$/,
                exclude: [/node_modules/],
                use: [
                  {
                    loader: 'ts-loader'
                  }
                ]
              }
            ]
          }
        },
        watchOptions: {}
      }))
    }
  }
})
```

## Core Features

### Basic Test Structure
- **Purpose**: Write end-to-end tests that simulate user interactions
- **Usage**: Create test files with Cypress commands and assertions
- **Example**:
```javascript
// cypress/e2e/basic-test.cy.js
describe('Basic Application Tests', () => {
  beforeEach(() => {
    // Visit the application before each test
    cy.visit('/')
  })

  it('should display the homepage', () => {
    cy.contains('Welcome to Our App')
    cy.get('[data-testid="hero-section"]').should('be.visible')
  })

  it('should navigate to about page', () => {
    cy.get('[data-testid="nav-about"]').click()
    cy.url().should('include', '/about')
    cy.contains('About Us')
  })

  it('should handle form submission', () => {
    cy.get('[data-testid="contact-form"]').within(() => {
      cy.get('input[name="name"]').type('John Doe')
      cy.get('input[name="email"]').type('john@example.com')
      cy.get('textarea[name="message"]').type('Test message')
      cy.get('button[type="submit"]').click()
    })

    cy.contains('Message sent successfully')
  })
})
```

### Element Interaction
- **Purpose**: Interact with page elements like clicking, typing, and selecting
- **Usage**: Use Cypress commands to simulate user actions
- **Example**:
```javascript
describe('Element Interactions', () => {
  beforeEach(() => {
    cy.visit('/interactive-demo')
  })

  it('should handle various input types', () => {
    // Text input
    cy.get('#username').type('testuser')
    cy.get('#username').should('have.value', 'testuser')

    // Password input
    cy.get('#password').type('password123{enter}')

    // Checkbox
    cy.get('#terms').check()
    cy.get('#terms').should('be.checked')

    // Radio buttons
    cy.get('[name="plan"]').check('premium')
    cy.get('#plan-premium').should('be.checked')

    // Select dropdown
    cy.get('#country').select('United States')
    cy.get('#country').should('have.value', 'US')

    // Multi-select
    cy.get('#skills').select(['JavaScript', 'Python', 'React'])
  })

  it('should handle mouse interactions', () => {
    // Click
    cy.get('#click-button').click()

    // Double click
    cy.get('#double-click-area').dblclick()

    // Right click
    cy.get('#context-menu').rightclick()

    // Hover
    cy.get('#hover-element').trigger('mouseover')
    cy.get('#tooltip').should('be.visible')

    // Drag and drop
    cy.get('#draggable').drag('#drop-zone')
  })

  it('should handle keyboard interactions', () => {
    cy.get('#text-editor').type('{ctrl+a}')
    cy.get('#text-editor').type('New content')
    cy.get('#text-editor').type('{ctrl+s}')

    // Special keys
    cy.get('body').type('{esc}')
    cy.get('#search-input').type('search term{enter}')
  })
})
```

### API Testing
- **Purpose**: Test API endpoints and intercept network requests
- **Usage**: Use cy.request() for API calls and cy.intercept() for mocking
- **Example**:
```javascript
describe('API Testing', () => {
  it('should make direct API calls', () => {
    cy.request({
      method: 'GET',
      url: '/api/users'
    }).then((response) => {
      expect(response.status).to.eq(200)
      expect(response.body).to.have.property('users')
      expect(response.body.users).to.be.an('array')
    })
  })

  it('should test POST requests', () => {
    cy.request({
      method: 'POST',
      url: '/api/users',
      body: {
        name: 'John Doe',
        email: 'john@example.com'
      }
    }).then((response) => {
      expect(response.status).to.eq(201)
      expect(response.body.user.name).to.eq('John Doe')
    })
  })

  it('should intercept and mock API calls', () => {
    // Intercept API call
    cy.intercept('GET', '/api/users', {
      fixture: 'users.json'
    }).as('getUsers')

    cy.visit('/users')
    cy.wait('@getUsers')

    // Verify mock data is displayed
    cy.contains('Test User 1')
    cy.contains('Test User 2')
  })

  it('should test error handling', () => {
    cy.intercept('GET', '/api/users', {
      statusCode: 500,
      body: { error: 'Internal Server Error' }
    }).as('getUsersError')

    cy.visit('/users')
    cy.wait('@getUsersError')

    cy.contains('Error loading users')
  })
})
```

## Common Commands
```bash
# Test execution
npx cypress run                       # Run all tests in headless mode
npx cypress run --spec "cypress/e2e/login.cy.js"  # Run specific test file
npx cypress run --browser chrome     # Run in specific browser
npx cypress run --headed              # Run in headed mode

# Interactive test runner
npx cypress open                      # Open Cypress Test Runner
npx cypress open --browser firefox   # Open with specific browser
npx cypress open --e2e               # Open e2e testing mode
npx cypress open --component         # Open component testing mode

# Environment and configuration
npx cypress run --env key=value      # Set environment variables
npx cypress run --config baseUrl=http://localhost:4000  # Override config
npx cypress run --config-file cypress.dev.config.js    # Use different config

# Test filtering
npx cypress run --spec "cypress/e2e/**/*auth*"  # Run tests matching pattern
npx cypress run --grep "should login"           # Run tests matching text

# Recording and reporting
npx cypress run --record --key <record-key>     # Record to Cypress Dashboard
npx cypress run --reporter json                 # Use specific reporter
npx cypress run --reporter-options mochaFile=results.xml

# Browser options
npx cypress run --browser chrome --headless     # Chrome headless
npx cypress run --browser firefox               # Firefox
npx cypress run --browser edge                  # Microsoft Edge

# Parallel execution
npx cypress run --parallel --record --key <key> # Run tests in parallel
npx cypress run --ci-build-id $BUILD_ID         # Set CI build ID

# Development commands
npx cypress verify                   # Verify Cypress installation
npx cypress cache clear             # Clear Cypress cache
npx cypress info                    # Show Cypress and system info
npx cypress version                 # Show version information
```

## Advanced Features

### Custom Commands
```javascript
// cypress/support/commands.js
Cypress.Commands.add('login', (username, password) => {
  cy.session([username, password], () => {
    cy.visit('/login')
    cy.get('[data-testid="username"]').type(username)
    cy.get('[data-testid="password"]').type(password)
    cy.get('[data-testid="login-button"]').click()
    cy.url().should('not.include', '/login')
  })
})

Cypress.Commands.add('loginAPI', (username, password) => {
  cy.request({
    method: 'POST',
    url: '/api/auth/login',
    body: { username, password }
  }).then((response) => {
    window.localStorage.setItem('authToken', response.body.token)
  })
})

Cypress.Commands.add('seedDatabase', () => {
  cy.task('seedDatabase')
})

Cypress.Commands.add('clearDatabase', () => {
  cy.task('clearDatabase')
})

// Usage in tests
describe('User Authentication', () => {
  it('should login user', () => {
    cy.login('testuser', 'password123')
    cy.visit('/dashboard')
    cy.contains('Welcome, testuser')
  })

  it('should login via API', () => {
    cy.loginAPI('testuser', 'password123')
    cy.visit('/dashboard')
    cy.contains('Dashboard')
  })
})
```

### Page Object Model
```javascript
// cypress/support/page-objects/LoginPage.js
class LoginPage {
  visit() {
    cy.visit('/login')
  }

  get usernameInput() {
    return cy.get('[data-testid="username"]')
  }

  get passwordInput() {
    return cy.get('[data-testid="password"]')
  }

  get loginButton() {
    return cy.get('[data-testid="login-button"]')
  }

  get errorMessage() {
    return cy.get('[data-testid="error-message"]')
  }

  login(username, password) {
    this.usernameInput.type(username)
    this.passwordInput.type(password)
    this.loginButton.click()
  }

  verifyLoginError(message) {
    this.errorMessage.should('contain', message)
  }
}

export default LoginPage

// Usage in tests
import LoginPage from '../support/page-objects/LoginPage'

describe('Login Tests', () => {
  const loginPage = new LoginPage()

  it('should display error for invalid credentials', () => {
    loginPage.visit()
    loginPage.login('invalid', 'credentials')
    loginPage.verifyLoginError('Invalid username or password')
  })
})
```

### Fixtures and Data Management
```javascript
// cypress/fixtures/users.json
{
  "validUser": {
    "username": "testuser",
    "password": "password123",
    "email": "test@example.com"
  },
  "adminUser": {
    "username": "admin",
    "password": "admin123",
    "email": "admin@example.com"
  }
}

// Using fixtures in tests
describe('User Management', () => {
  beforeEach(() => {
    cy.fixture('users').as('userData')
  })

  it('should create a new user', function() {
    cy.visit('/admin/users')
    cy.get('#create-user-button').click()

    cy.get('#username').type(this.userData.validUser.username)
    cy.get('#email').type(this.userData.validUser.email)
    cy.get('#password').type(this.userData.validUser.password)

    cy.get('#save-button').click()
    cy.contains('User created successfully')
  })

  it('should load fixture data dynamically', () => {
    cy.fixture('users').then((users) => {
      cy.login(users.adminUser.username, users.adminUser.password)
      cy.visit('/admin/dashboard')
    })
  })
})
```

### File Upload Testing
```javascript
describe('File Upload', () => {
  it('should upload a file', () => {
    cy.visit('/upload')

    // Upload file from fixtures
    cy.get('#file-input').selectFile('cypress/fixtures/sample.pdf')

    // Upload multiple files
    cy.get('#multiple-files').selectFile([
      'cypress/fixtures/file1.txt',
      'cypress/fixtures/file2.txt'
    ])

    // Upload with drag and drop
    cy.get('#drop-zone').selectFile('cypress/fixtures/image.png', {
      action: 'drag-drop'
    })

    // Verify upload
    cy.contains('File uploaded successfully')
  })

  it('should handle file upload errors', () => {
    cy.visit('/upload')

    // Try to upload invalid file type
    cy.get('#file-input').selectFile('cypress/fixtures/invalid.exe', {
      force: true
    })

    cy.contains('Invalid file type')
  })
})
```

## Testing Patterns

### Authentication Testing
```javascript
describe('Authentication Flow', () => {
  beforeEach(() => {
    cy.clearCookies()
    cy.clearLocalStorage()
  })

  it('should handle successful login', () => {
    cy.visit('/login')

    cy.get('[data-testid="username"]').type('testuser')
    cy.get('[data-testid="password"]').type('password123')
    cy.get('[data-testid="login-button"]').click()

    // Verify redirect
    cy.url().should('include', '/dashboard')
    cy.get('[data-testid="user-menu"]').should('contain', 'testuser')

    // Verify session persistence
    cy.reload()
    cy.url().should('include', '/dashboard')
  })

  it('should handle login failure', () => {
    cy.visit('/login')

    cy.get('[data-testid="username"]').type('invalid')
    cy.get('[data-testid="password"]').type('wrongpassword')
    cy.get('[data-testid="login-button"]').click()

    cy.get('[data-testid="error-message"]').should(
      'contain',
      'Invalid credentials'
    )
    cy.url().should('include', '/login')
  })

  it('should handle logout', () => {
    cy.login('testuser', 'password123')
    cy.visit('/dashboard')

    cy.get('[data-testid="user-menu"]').click()
    cy.get('[data-testid="logout-button"]').click()

    cy.url().should('include', '/login')
    cy.get('[data-testid="login-form"]').should('be.visible')
  })

  it('should protect routes', () => {
    cy.visit('/dashboard')
    cy.url().should('include', '/login')

    cy.visit('/admin')
    cy.url().should('include', '/login')
  })
})
```

### E-commerce Testing
```javascript
describe('E-commerce Flow', () => {
  beforeEach(() => {
    cy.seedDatabase()
    cy.visit('/')
  })

  it('should complete a purchase', () => {
    // Browse products
    cy.get('[data-testid="product-grid"]').should('be.visible')
    cy.get('[data-testid="product-card"]').first().click()

    // Add to cart
    cy.get('[data-testid="size-select"]').select('Medium')
    cy.get('[data-testid="color-select"]').select('Blue')
    cy.get('[data-testid="add-to-cart"]').click()

    // Verify cart update
    cy.get('[data-testid="cart-count"]').should('contain', '1')

    // Go to cart
    cy.get('[data-testid="cart-icon"]').click()
    cy.url().should('include', '/cart')

    // Verify cart contents
    cy.get('[data-testid="cart-item"]').should('have.length', 1)
    cy.get('[data-testid="item-name"]').should('contain', 'Test Product')

    // Proceed to checkout
    cy.get('[data-testid="checkout-button"]').click()

    // Fill shipping information
    cy.get('#firstName').type('John')
    cy.get('#lastName').type('Doe')
    cy.get('#address').type('123 Main St')
    cy.get('#city').type('New York')
    cy.get('#state').select('NY')
    cy.get('#zipCode').type('10001')

    // Continue to payment
    cy.get('[data-testid="continue-to-payment"]').click()

    // Fill payment information
    cy.get('#cardNumber').type('4111111111111111')
    cy.get('#expiryDate').type('12/25')
    cy.get('#cvv').type('123')

    // Complete purchase
    cy.get('[data-testid="place-order"]').click()

    // Verify order confirmation
    cy.url().should('include', '/order-confirmation')
    cy.get('[data-testid="order-number"]').should('be.visible')
    cy.contains('Thank you for your order')
  })

  it('should handle cart management', () => {
    // Add multiple items
    cy.addToCart('product-1', { size: 'Medium', color: 'Blue' })
    cy.addToCart('product-2', { size: 'Large', color: 'Red' })

    cy.visit('/cart')

    // Update quantities
    cy.get('[data-testid="quantity-input"]').first().clear().type('2')
    cy.get('[data-testid="update-cart"]').click()

    // Remove item
    cy.get('[data-testid="remove-item"]').first().click()
    cy.get('[data-testid="cart-item"]').should('have.length', 1)

    // Apply coupon
    cy.get('#coupon-code').type('SAVE10')
    cy.get('[data-testid="apply-coupon"]').click()
    cy.get('[data-testid="discount-amount"]').should('be.visible')
  })
})
```

### Form Testing
```javascript
describe('Contact Form', () => {
  beforeEach(() => {
    cy.visit('/contact')
  })

  it('should submit form successfully', () => {
    cy.get('#name').type('John Doe')
    cy.get('#email').type('john@example.com')
    cy.get('#subject').select('General Inquiry')
    cy.get('#message').type('This is a test message from Cypress.')
    cy.get('#terms').check()

    // Intercept form submission
    cy.intercept('POST', '/api/contact', {
      statusCode: 200,
      body: { success: true, message: 'Message sent successfully' }
    }).as('submitForm')

    cy.get('[data-testid="submit-button"]').click()
    cy.wait('@submitForm')

    cy.get('[data-testid="success-message"]').should(
      'contain',
      'Thank you for your message'
    )
  })

  it('should validate required fields', () => {
    cy.get('[data-testid="submit-button"]').click()

    cy.get('#name-error').should('contain', 'Name is required')
    cy.get('#email-error').should('contain', 'Email is required')
    cy.get('#message-error').should('contain', 'Message is required')
  })

  it('should validate email format', () => {
    cy.get('#email').type('invalid-email')
    cy.get('#email').blur()

    cy.get('#email-error').should('contain', 'Please enter a valid email')
  })

  it('should handle server errors', () => {
    cy.get('#name').type('John Doe')
    cy.get('#email').type('john@example.com')
    cy.get('#message').type('Test message')

    cy.intercept('POST', '/api/contact', {
      statusCode: 500,
      body: { error: 'Server error' }
    }).as('submitFormError')

    cy.get('[data-testid="submit-button"]').click()
    cy.wait('@submitFormError')

    cy.get('[data-testid="error-message"]').should(
      'contain',
      'Something went wrong'
    )
  })
})
```

## Environment-Specific Configuration

### CI/CD Integration
```yaml
# GitHub Actions (.github/workflows/cypress.yml)
name: Cypress Tests
on: [push, pull_request]

jobs:
  cypress-run:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        browser: [chrome, firefox, edge]

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: 18
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Start application
      run: npm start &

    - name: Wait for application
      run: npx wait-on http://localhost:3000

    - name: Run Cypress tests
      uses: cypress-io/github-action@v6
      with:
        browser: ${{ matrix.browser }}
        record: true
        parallel: true
      env:
        CYPRESS_RECORD_KEY: ${{ secrets.CYPRESS_RECORD_KEY }}
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

    - name: Upload screenshots
      uses: actions/upload-artifact@v3
      if: failure()
      with:
        name: cypress-screenshots-${{ matrix.browser }}
        path: cypress/screenshots

    - name: Upload videos
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: cypress-videos-${{ matrix.browser }}
        path: cypress/videos
```

### Docker Integration
```dockerfile
# Dockerfile for Cypress
FROM cypress/included:13.6.0

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Run tests
CMD ["npx", "cypress", "run"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=test

  cypress:
    image: cypress/included:13.6.0
    depends_on:
      - app
    environment:
      - CYPRESS_baseUrl=http://app:3000
    working_dir: /e2e
    volumes:
      - ./cypress:/e2e/cypress
      - ./cypress.config.js:/e2e/cypress.config.js
      - ./package.json:/e2e/package.json
```

## Common Issues & Solutions

### Flaky Tests
**Problem**: Tests fail intermittently due to timing issues
**Solution**: Use proper waiting strategies
```javascript
// ❌ Bad: Fixed waits
cy.wait(1000)
cy.get('#element').click()

// ✅ Good: Wait for conditions
cy.get('#loading-spinner').should('not.exist')
cy.get('#element').should('be.visible').click()

// ❌ Bad: Immediate assertions
cy.get('#submit').click()
cy.get('#success-message').should('exist')

// ✅ Good: Wait for assertions
cy.get('#submit').click()
cy.get('#success-message', { timeout: 10000 }).should('be.visible')
```

### Element Not Found
**Problem**: Elements are not found due to dynamic loading
**Solution**: Use better selectors and waits
```javascript
// ❌ Bad: Brittle selectors
cy.get('div > span:nth-child(2)')

// ✅ Good: Data attributes
cy.get('[data-testid="submit-button"]')
cy.get('[data-cy="user-menu"]')

// Wait for dynamic content
cy.get('[data-testid="user-list"]').should('exist')
cy.get('[data-testid="user-item"]').should('have.length.gt', 0)
```

### Network Issues
**Problem**: Tests fail due to external dependencies
**Solution**: Mock external services
```javascript
// Mock external APIs
cy.intercept('GET', 'https://api.external.com/**', {
  fixture: 'external-api-response.json'
})

// Block unnecessary requests
cy.intercept('GET', '**/*.png', { fixture: 'placeholder.png' })
cy.intercept('GET', '**/analytics/**', req => req.reply(200))
```

## Useful Resources
- **Official Documentation**: https://docs.cypress.io/
- **API Reference**: https://docs.cypress.io/api/table-of-contents
- **Best Practices**: https://docs.cypress.io/guides/references/best-practices
- **Examples Repository**: https://github.com/cypress-io/cypress-example-kitchensink
- **Discord Community**: https://discord.gg/cypress

## Tool-Specific Guidelines

### Best Practices
- Use data-testid attributes for reliable element selection
- Keep tests independent and isolated
- Use custom commands for common operations
- Mock external dependencies and APIs
- Leverage Cypress's automatic waiting capabilities

### Performance Tips
- Run tests in parallel for faster execution
- Use cy.session() for authentication state
- Minimize the use of cy.wait() with fixed times
- Use cy.intercept() to speed up network requests
- Clear application state between tests

### Security Considerations
- Never commit real credentials in test files
- Use environment variables for sensitive data
- Implement proper test data management
- Use baseUrl to avoid hardcoded URLs
- Validate authentication and authorization flows

## Version Compatibility
- **Node.js**: 18+ (16+ minimum)
- **Browsers**: Chrome 64+, Firefox 86+, Edge 79+, Safari 12+
- **Operating Systems**: Windows, macOS, Linux

## Troubleshooting

### Debug Mode
```bash
# Open Cypress with debug info
DEBUG=cypress:* npx cypress open

# Run with verbose logging
npx cypress run --record --key <key> --parallel

# Check Cypress installation
npx cypress verify
npx cypress info
```

### Common Error Messages
- **Error**: `Timed out retrying after 4000ms`
  **Cause**: Element not found or condition not met
  **Solution**: Increase timeout or fix selector

- **Error**: `cy.visit() failed trying to load`
  **Cause**: Application not running or incorrect URL
  **Solution**: Start application server or check baseUrl

- **Error**: `The following error originated from your test code`
  **Cause**: JavaScript error in application or test
  **Solution**: Check browser console and fix application errors
````
