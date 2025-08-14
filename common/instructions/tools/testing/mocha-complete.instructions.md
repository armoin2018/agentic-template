````instructions
# Mocha JavaScript Testing Framework Instructions

## Tool Overview
- **Tool Name**: Mocha
- **Version**: 10.2+ (stable), 10.7+ (latest with enhanced features)
- **Category**: Testing Tools
- **Purpose**: Feature-rich JavaScript test framework running on Node.js and browsers
- **Prerequisites**: Node.js 16+ (18+ recommended), npm/yarn/pnpm

## Installation & Setup
### Package Manager Installation
```bash
# npm installation
npm install --save-dev mocha
npm install --save-dev mocha chai sinon

# yarn installation
yarn add --dev mocha
yarn add --dev mocha chai sinon

# pnpm installation
pnpm add -D mocha
pnpm add -D mocha chai sinon

# Global installation (not recommended for projects)
npm install -g mocha

# With additional testing utilities
npm install --save-dev chai chai-as-promised sinon-chai
npm install --save-dev @types/mocha @types/chai @types/sinon  # For TypeScript

# For browser testing
npm install --save-dev mocha puppeteer karma karma-mocha
```

### Project Integration
```bash
# Initialize package.json test script
npm init -y
npm install --save-dev mocha

# Add to package.json scripts
{
  "scripts": {
    "test": "mocha",
    "test:watch": "mocha --watch",
    "test:coverage": "nyc mocha"
  }
}

# Create test directory structure
mkdir test
touch test/test.js

# Or create tests alongside source
mkdir src
mkdir src/__tests__
```

### Basic Configuration
```javascript
// .mocharc.json
{
  "spec": ["test/**/*.js", "src/**/*.test.js"],
  "recursive": true,
  "reporter": "spec",
  "timeout": 5000,
  "slow": 75,
  "bail": false,
  "exit": true,
  "require": ["test/setup.js"]
}

// .mocharc.js (for dynamic configuration)
module.exports = {
  spec: ['test/**/*.js'],
  recursive: true,
  reporter: process.env.CI ? 'json' : 'spec',
  timeout: process.env.CI ? 10000 : 5000,
  require: ['test/setup.js'],
  parallel: process.env.CI ? true : false
}
```

## Core Features

### Basic Test Structure
- **Purpose**: Write structured unit tests with describe blocks and it statements
- **Usage**: Organize tests hierarchically with nested describe blocks
- **Example**:
```javascript
// test/basic.test.js
const { expect } = require('chai')
const Calculator = require('../src/calculator')

describe('Calculator', () => {
  let calculator

  beforeEach(() => {
    calculator = new Calculator()
  })

  afterEach(() => {
    calculator = null
  })

  describe('addition', () => {
    it('should add two positive numbers', () => {
      const result = calculator.add(2, 3)
      expect(result).to.equal(5)
    })

    it('should add negative numbers', () => {
      const result = calculator.add(-2, -3)
      expect(result).to.equal(-5)
    })

    it('should handle zero', () => {
      const result = calculator.add(5, 0)
      expect(result).to.equal(5)
    })
  })

  describe('subtraction', () => {
    it('should subtract numbers correctly', () => {
      const result = calculator.subtract(10, 3)
      expect(result).to.equal(7)
    })

    it('should handle negative results', () => {
      const result = calculator.subtract(3, 10)
      expect(result).to.equal(-7)
    })
  })
})
```

### Assertions with Chai
- **Purpose**: Provide expressive and readable assertions for test validation
- **Usage**: Chain assertion methods for natural language-like tests
- **Example**:
```javascript
const { expect, assert, should } = require('chai')

describe('Chai Assertion Styles', () => {
  const user = {
    name: 'John Doe',
    age: 30,
    email: 'john@example.com',
    roles: ['user', 'admin']
  }

  describe('Expect style (recommended)', () => {
    it('should validate object properties', () => {
      expect(user).to.be.an('object')
      expect(user).to.have.property('name')
      expect(user.name).to.equal('John Doe')
      expect(user.age).to.be.a('number').and.be.above(18)
      expect(user.email).to.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)
      expect(user.roles).to.be.an('array').with.length(2)
      expect(user.roles).to.include('admin')
    })

    it('should validate arrays and objects', () => {
      const numbers = [1, 2, 3, 4, 5]

      expect(numbers).to.have.length(5)
      expect(numbers).to.include(3)
      expect(numbers).to.deep.equal([1, 2, 3, 4, 5])
      expect(numbers).to.satisfy(arr => arr.every(n => n > 0))
    })

    it('should handle async assertions', async () => {
      const promise = Promise.resolve('success')

      await expect(promise).to.eventually.equal('success')
      await expect(Promise.reject(new Error('failed')))
        .to.be.rejectedWith('failed')
    })
  })

  describe('Assert style', () => {
    it('should use assert statements', () => {
      assert.equal(user.name, 'John Doe')
      assert.isNumber(user.age)
      assert.isArray(user.roles)
      assert.include(user.roles, 'admin')
      assert.match(user.email, /^[^\s@]+@[^\s@]+\.[^\s@]+$/)
    })
  })

  describe('Should style', () => {
    before(() => {
      should()  // Modifies Object.prototype
    })

    it('should use should assertions', () => {
      user.should.be.an('object')
      user.should.have.property('name', 'John Doe')
      user.age.should.be.a('number').and.be.above(18)
      user.roles.should.have.length(2)
    })
  })
})
```

### Mocking with Sinon
- **Purpose**: Create spies, stubs, and mocks for isolated unit testing
- **Usage**: Replace dependencies and track function calls
- **Example**:
```javascript
const sinon = require('sinon')
const { expect } = require('chai')
const UserService = require('../src/user-service')
const EmailService = require('../src/email-service')

describe('UserService with Sinon', () => {
  let userService
  let emailStub
  let sandbox

  beforeEach(() => {
    sandbox = sinon.createSandbox()
    emailStub = sandbox.stub(EmailService, 'send')
    userService = new UserService()
  })

  afterEach(() => {
    sandbox.restore()
  })

  describe('spies', () => {
    it('should track function calls', () => {
      const callback = sinon.spy()
      const user = { name: 'John', email: 'john@example.com' }

      userService.processUser(user, callback)

      expect(callback.calledOnce).to.be.true
      expect(callback.calledWith(user)).to.be.true
    })
  })

  describe('stubs', () => {
    it('should stub external dependencies', () => {
      emailStub.returns(Promise.resolve({ success: true }))

      const user = { name: 'John', email: 'john@example.com' }
      return userService.sendWelcomeEmail(user).then(result => {
        expect(emailStub.calledOnce).to.be.true
        expect(emailStub.calledWith(user.email)).to.be.true
        expect(result.success).to.be.true
      })
    })

    it('should stub with different return values', () => {
      const dbStub = sandbox.stub(userService, 'findById')

      dbStub.withArgs(1).returns({ id: 1, name: 'John' })
      dbStub.withArgs(2).returns({ id: 2, name: 'Jane' })
      dbStub.withArgs(999).returns(null)

      expect(userService.findById(1)).to.deep.equal({ id: 1, name: 'John' })
      expect(userService.findById(2)).to.deep.equal({ id: 2, name: 'Jane' })
      expect(userService.findById(999)).to.be.null
    })
  })

  describe('mocks', () => {
    it('should use mocks for complex scenarios', () => {
      const mock = sandbox.mock(EmailService)

      mock.expects('send').once().withArgs('john@example.com').returns(true)
      mock.expects('send').never().withArgs('invalid@email')

      userService.sendEmail('john@example.com')

      mock.verify()
    })
  })
})
```

## Common Commands
```bash
# Basic test execution
mocha                                    # Run all tests
mocha test/specific-test.js             # Run specific test file
mocha "test/**/*.test.js"               # Run tests matching pattern

# Watch mode
mocha --watch                           # Watch for changes and re-run tests
mocha --watch --grep "User"            # Watch and filter tests

# Reporting options
mocha --reporter spec                   # Default spec reporter
mocha --reporter json                   # JSON output
mocha --reporter html                   # HTML report
mocha --reporter tap                    # TAP format
mocha --reporter xunit                  # xUnit XML format
mocha --reporter nyan                   # Nyan cat reporter (fun!)

# Test filtering
mocha --grep "should add"               # Run tests matching pattern
mocha --grep "User.*create"             # Use regex patterns
mocha --invert --grep "slow"            # Exclude tests matching pattern

# Timeouts and performance
mocha --timeout 5000                    # Set global timeout
mocha --slow 100                        # Mark tests slower than 100ms
mocha --bail                            # Stop on first failure

# Parallel execution
mocha --parallel                        # Run tests in parallel
mocha --jobs 4                          # Specify number of parallel jobs

# Coverage with NYC
nyc mocha                               # Run with coverage
nyc --reporter=html mocha               # HTML coverage report
nyc --reporter=lcov mocha               # LCOV format for CI

# Browser testing
mocha --require jsdom-global/register   # Run in jsdom environment
mocha-webpack test/**/*.js              # Use with webpack
```

## Advanced Features

### Hooks and Setup
```javascript
describe('Advanced Hooks', () => {
  // Run once before all tests in this describe block
  before(async () => {
    console.log('Setting up test database...')
    await setupTestDatabase()
  })

  // Run once after all tests in this describe block
  after(async () => {
    console.log('Cleaning up test database...')
    await cleanupTestDatabase()
  })

  // Run before each test
  beforeEach(async () => {
    console.log('Seeding test data...')
    await seedTestData()
  })

  // Run after each test
  afterEach(async () => {
    console.log('Cleaning test data...')
    await cleanTestData()
  })

  describe('nested describe', () => {
    // Hooks in nested describe blocks run in addition to parent hooks
    beforeEach(() => {
      console.log('Additional setup for nested tests')
    })

    it('should have access to all hooks', () => {
      // This test will run:
      // 1. parent before
      // 2. parent beforeEach
      // 3. nested beforeEach
      // 4. test
      // 5. nested afterEach (if exists)
      // 6. parent afterEach
      expect(true).to.be.true
    })
  })
})
```

### Asynchronous Testing
```javascript
describe('Async Testing Patterns', () => {
  it('should handle promises', () => {
    return fetchUserData(1).then(user => {
      expect(user).to.have.property('id', 1)
      expect(user).to.have.property('name')
    })
  })

  it('should handle async/await', async () => {
    const user = await fetchUserData(1)
    expect(user).to.have.property('id', 1)
    expect(user).to.have.property('name')
  })

  it('should handle callbacks with done', (done) => {
    fetchUserDataCallback(1, (err, user) => {
      if (err) return done(err)

      try {
        expect(user).to.have.property('id', 1)
        done()
      } catch (error) {
        done(error)
      }
    })
  })

  it('should handle promise rejections', () => {
    return expect(fetchUserData(999))
      .to.be.rejectedWith('User not found')
  })

  it('should test with timeouts', async function() {
    this.timeout(10000)  // 10 second timeout for this test

    const result = await slowAsyncOperation()
    expect(result).to.be.ok
  })
})
```

### Custom Matchers and Helpers
```javascript
// test/helpers/custom-matchers.js
const chai = require('chai')

chai.use(function(chai, utils) {
  chai.Assertion.addMethod('evenNumber', function() {
    const obj = this._obj

    this.assert(
      obj % 2 === 0,
      'expected #{this} to be an even number',
      'expected #{this} to not be an even number',
      true,
      obj % 2 === 0
    )
  })

  chai.Assertion.addMethod('validEmail', function() {
    const obj = this._obj
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

    this.assert(
      emailRegex.test(obj),
      'expected #{this} to be a valid email',
      'expected #{this} to not be a valid email',
      true,
      emailRegex.test(obj)
    )
  })
})

// Usage in tests
describe('Custom Matchers', () => {
  it('should use custom even number matcher', () => {
    expect(4).to.be.an.evenNumber()
    expect(3).to.not.be.an.evenNumber()
  })

  it('should use custom email matcher', () => {
    expect('user@example.com').to.be.a.validEmail()
    expect('invalid-email').to.not.be.a.validEmail()
  })
})
```

### Test Organization Patterns
```javascript
// test/integration/user-api.test.js
describe('User API Integration Tests', () => {
  let app
  let request

  before(async () => {
    app = await createTestApp()
    request = require('supertest')(app)
  })

  describe('POST /api/users', () => {
    it('should create a new user', async () => {
      const userData = {
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123'
      }

      const response = await request
        .post('/api/users')
        .send(userData)
        .expect(201)

      expect(response.body).to.have.property('id')
      expect(response.body.name).to.equal(userData.name)
      expect(response.body.email).to.equal(userData.email)
      expect(response.body).to.not.have.property('password')
    })

    it('should validate required fields', async () => {
      const response = await request
        .post('/api/users')
        .send({})
        .expect(400)

      expect(response.body).to.have.property('errors')
      expect(response.body.errors).to.include('Name is required')
      expect(response.body.errors).to.include('Email is required')
    })
  })

  describe('GET /api/users/:id', () => {
    let userId

    beforeEach(async () => {
      const user = await createTestUser()
      userId = user.id
    })

    it('should get user by id', async () => {
      const response = await request
        .get(`/api/users/${userId}`)
        .expect(200)

      expect(response.body).to.have.property('id', userId)
      expect(response.body).to.have.property('name')
      expect(response.body).to.have.property('email')
    })

    it('should return 404 for non-existent user', async () => {
      await request
        .get('/api/users/999999')
        .expect(404)
    })
  })
})
```

## Testing Patterns

### Unit Testing
```javascript
// src/calculator.js
class Calculator {
  add(a, b) {
    if (typeof a !== 'number' || typeof b !== 'number') {
      throw new Error('Arguments must be numbers')
    }
    return a + b
  }

  divide(a, b) {
    if (b === 0) {
      throw new Error('Division by zero')
    }
    return a / b
  }

  calculate(expression) {
    // Complex calculation logic
    const parts = expression.split(' ')
    const a = parseFloat(parts[0])
    const operator = parts[1]
    const b = parseFloat(parts[2])

    switch (operator) {
      case '+': return this.add(a, b)
      case '-': return a - b
      case '*': return a * b
      case '/': return this.divide(a, b)
      default: throw new Error('Unknown operator')
    }
  }
}

// test/calculator.test.js
describe('Calculator', () => {
  let calculator

  beforeEach(() => {
    calculator = new Calculator()
  })

  describe('add method', () => {
    it('should add two positive numbers', () => {
      expect(calculator.add(2, 3)).to.equal(5)
    })

    it('should add negative numbers', () => {
      expect(calculator.add(-2, -3)).to.equal(-5)
    })

    it('should handle decimal numbers', () => {
      expect(calculator.add(0.1, 0.2)).to.be.closeTo(0.3, 0.001)
    })

    it('should throw error for non-numeric inputs', () => {
      expect(() => calculator.add('a', 2)).to.throw('Arguments must be numbers')
      expect(() => calculator.add(2, null)).to.throw('Arguments must be numbers')
    })
  })

  describe('divide method', () => {
    it('should divide numbers correctly', () => {
      expect(calculator.divide(10, 2)).to.equal(5)
    })

    it('should handle decimal results', () => {
      expect(calculator.divide(1, 3)).to.be.closeTo(0.333, 0.001)
    })

    it('should throw error for division by zero', () => {
      expect(() => calculator.divide(5, 0)).to.throw('Division by zero')
    })
  })

  describe('calculate method', () => {
    it('should parse and calculate expressions', () => {
      expect(calculator.calculate('5 + 3')).to.equal(8)
      expect(calculator.calculate('10 - 4')).to.equal(6)
      expect(calculator.calculate('6 * 7')).to.equal(42)
      expect(calculator.calculate('15 / 3')).to.equal(5)
    })

    it('should handle unknown operators', () => {
      expect(() => calculator.calculate('5 % 3')).to.throw('Unknown operator')
    })
  })
})
```

### Service Layer Testing
```javascript
// src/user-service.js
class UserService {
  constructor(userRepository, emailService) {
    this.userRepository = userRepository
    this.emailService = emailService
  }

  async createUser(userData) {
    // Validate email
    if (!this.isValidEmail(userData.email)) {
      throw new Error('Invalid email format')
    }

    // Check if user exists
    const existingUser = await this.userRepository.findByEmail(userData.email)
    if (existingUser) {
      throw new Error('User already exists')
    }

    // Create user
    const user = await this.userRepository.create(userData)

    // Send welcome email
    await this.emailService.sendWelcomeEmail(user.email, user.name)

    return user
  }

  async getUserById(id) {
    if (!id) {
      throw new Error('User ID is required')
    }

    const user = await this.userRepository.findById(id)
    if (!user) {
      throw new Error('User not found')
    }

    return user
  }

  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }
}

// test/user-service.test.js
describe('UserService', () => {
  let userService
  let userRepositoryStub
  let emailServiceStub
  let sandbox

  beforeEach(() => {
    sandbox = sinon.createSandbox()

    userRepositoryStub = {
      findByEmail: sandbox.stub(),
      findById: sandbox.stub(),
      create: sandbox.stub()
    }

    emailServiceStub = {
      sendWelcomeEmail: sandbox.stub()
    }

    userService = new UserService(userRepositoryStub, emailServiceStub)
  })

  afterEach(() => {
    sandbox.restore()
  })

  describe('createUser', () => {
    const validUserData = {
      name: 'John Doe',
      email: 'john@example.com',
      password: 'password123'
    }

    it('should create a new user successfully', async () => {
      const createdUser = { id: 1, ...validUserData }

      userRepositoryStub.findByEmail.resolves(null)
      userRepositoryStub.create.resolves(createdUser)
      emailServiceStub.sendWelcomeEmail.resolves()

      const result = await userService.createUser(validUserData)

      expect(userRepositoryStub.findByEmail.calledWith(validUserData.email)).to.be.true
      expect(userRepositoryStub.create.calledWith(validUserData)).to.be.true
      expect(emailServiceStub.sendWelcomeEmail.calledWith(validUserData.email, validUserData.name)).to.be.true
      expect(result).to.deep.equal(createdUser)
    })

    it('should throw error for invalid email', async () => {
      const invalidUserData = { ...validUserData, email: 'invalid-email' }

      await expect(userService.createUser(invalidUserData))
        .to.be.rejectedWith('Invalid email format')

      expect(userRepositoryStub.findByEmail.called).to.be.false
    })

    it('should throw error if user already exists', async () => {
      userRepositoryStub.findByEmail.resolves({ id: 1 })

      await expect(userService.createUser(validUserData))
        .to.be.rejectedWith('User already exists')

      expect(userRepositoryStub.create.called).to.be.false
      expect(emailServiceStub.sendWelcomeEmail.called).to.be.false
    })
  })

  describe('getUserById', () => {
    it('should return user for valid ID', async () => {
      const user = { id: 1, name: 'John Doe', email: 'john@example.com' }
      userRepositoryStub.findById.resolves(user)

      const result = await userService.getUserById(1)

      expect(userRepositoryStub.findById.calledWith(1)).to.be.true
      expect(result).to.deep.equal(user)
    })

    it('should throw error for missing ID', async () => {
      await expect(userService.getUserById()).to.be.rejectedWith('User ID is required')
      await expect(userService.getUserById(null)).to.be.rejectedWith('User ID is required')
    })

    it('should throw error if user not found', async () => {
      userRepositoryStub.findById.resolves(null)

      await expect(userService.getUserById(999)).to.be.rejectedWith('User not found')
    })
  })
})
```

## Configuration Examples

### TypeScript Configuration
```javascript
// mocha.opts or .mocharc.json
{
  "require": ["ts-node/register"],
  "extensions": ["ts"],
  "spec": "test/**/*.test.ts",
  "recursive": true
}

// tsconfig.json
{
  "compilerOptions": {
    "target": "es2018",
    "module": "commonjs",
    "lib": ["es2018"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "types": ["node", "mocha", "chai", "sinon"]
  },
  "include": ["src/**/*", "test/**/*"],
  "exclude": ["node_modules", "dist"]
}

// test/example.test.ts
import { expect } from 'chai'
import { Calculator } from '../src/calculator'

describe('Calculator TypeScript', () => {
  let calculator: Calculator

  beforeEach(() => {
    calculator = new Calculator()
  })

  it('should add numbers with type safety', () => {
    const result: number = calculator.add(2, 3)
    expect(result).to.equal(5)
  })
})
```

### ES6 Modules Configuration
```javascript
// .mocharc.json
{
  "require": ["@babel/register"],
  "spec": "test/**/*.test.js",
  "recursive": true
}

// babel.config.js
module.exports = {
  presets: [
    ['@babel/preset-env', {
      targets: { node: 'current' }
    }]
  ]
}

// test/example.test.js
import { expect } from 'chai'
import { Calculator } from '../src/calculator.js'

describe('ES6 Modules', () => {
  it('should work with import/export', () => {
    const calc = new Calculator()
    expect(calc.add(2, 3)).to.equal(5)
  })
})
```

### Browser Testing Configuration
```javascript
// karma.conf.js
module.exports = function(config) {
  config.set({
    frameworks: ['mocha', 'chai'],
    files: [
      'src/**/*.js',
      'test/**/*.test.js'
    ],
    browsers: ['Chrome', 'Firefox', 'Safari'],
    reporters: ['progress', 'coverage'],
    preprocessors: {
      'src/**/*.js': ['coverage']
    },
    coverageReporter: {
      type: 'html',
      dir: 'coverage/'
    }
  })
}

// package.json scripts
{
  "scripts": {
    "test:browser": "karma start",
    "test:node": "mocha",
    "test": "npm run test:node && npm run test:browser"
  }
}
```

## Coverage and Reporting

### NYC Coverage
```bash
# Install NYC
npm install --save-dev nyc

# Basic coverage
nyc mocha

# Coverage with different reporters
nyc --reporter=html --reporter=text mocha
nyc --reporter=lcov --reporter=text-summary mocha

# Coverage thresholds
nyc --check-coverage --lines 90 --functions 90 --branches 80 mocha
```

```javascript
// .nycrc.json
{
  "all": true,
  "check-coverage": true,
  "reporter": ["html", "text", "lcov"],
  "include": ["src/**/*.js"],
  "exclude": [
    "test/**",
    "coverage/**",
    "node_modules/**"
  ],
  "lines": 90,
  "functions": 90,
  "branches": 80,
  "statements": 90
}
```

### Custom Reporters
```javascript
// reporters/custom-reporter.js
const Base = require('mocha').reporters.Base

function CustomReporter(runner) {
  Base.call(this, runner)

  const tests = []
  const failures = []

  runner.on('test end', (test) => {
    tests.push(test)
  })

  runner.on('fail', (test, err) => {
    failures.push({ test, err })
  })

  runner.on('end', () => {
    console.log('\n=== Custom Test Report ===')
    console.log(`Total tests: ${tests.length}`)
    console.log(`Failures: ${failures.length}`)
    console.log(`Success rate: ${((tests.length - failures.length) / tests.length * 100).toFixed(2)}%`)

    if (failures.length > 0) {
      console.log('\nFailures:')
      failures.forEach(({ test, err }) => {
        console.log(`- ${test.fullTitle()}: ${err.message}`)
      })
    }
  })
}

module.exports = CustomReporter

// Usage: mocha --reporter ./reporters/custom-reporter.js
```

## Common Issues & Solutions

### Timeout Issues
**Problem**: Tests timeout due to long-running operations
**Solution**: Adjust timeouts appropriately
```javascript
describe('Long running tests', () => {
  it('should handle slow operations', function() {
    this.timeout(10000)  // 10 second timeout for this test

    return slowAsyncOperation()
  })
})

// Or globally in .mocharc.json
{
  "timeout": 5000
}
```

### Memory Leaks
**Problem**: Tests consume too much memory over time
**Solution**: Proper cleanup and test isolation
```javascript
describe('Memory management', () => {
  let heavyResource

  beforeEach(() => {
    heavyResource = createHeavyResource()
  })

  afterEach(() => {
    if (heavyResource && typeof heavyResource.cleanup === 'function') {
      heavyResource.cleanup()
    }
    heavyResource = null
  })
})
```

### Flaky Tests
**Problem**: Tests fail intermittently
**Solution**: Better test design and isolation
```javascript
// ❌ Bad: Dependent on external state
it('should have user count', () => {
  const count = getUserCount()
  expect(count).to.equal(5)  // Assumes specific state
})

// ✅ Good: Set up known state
it('should have user count', async () => {
  await createTestUsers(5)
  const count = getUserCount()
  expect(count).to.equal(5)
})
```

## Useful Resources
- **Official Documentation**: https://mochajs.org/
- **API Reference**: https://mochajs.org/api/
- **Chai Assertion Library**: https://www.chaijs.com/
- **Sinon Mocking Library**: https://sinonjs.org/
- **Examples Repository**: https://github.com/mochajs/mocha-examples

## Tool-Specific Guidelines

### Best Practices
- Use descriptive test names that explain what is being tested
- Keep tests focused and test one thing at a time
- Use proper setup and teardown with hooks
- Mock external dependencies to ensure test isolation
- Organize tests logically with nested describe blocks

### Performance Tips
- Use `--parallel` flag for faster test execution
- Implement proper cleanup to prevent memory leaks
- Use `--bail` to stop on first failure during development
- Consider test file organization for optimal parallel execution

### Security Considerations
- Never commit real credentials or sensitive data in tests
- Use environment variables or test-specific configuration
- Clean up test data and resources after test runs
- Use isolated test databases or mock services

## Version Compatibility
- **Node.js**: 16+ (14+ for older Mocha versions)
- **Browsers**: Modern browsers for browser testing
- **npm**: 6+ (comes with Node.js)

## Troubleshooting

### Debug Mode
```bash
# Run Mocha with debug output
DEBUG=mocha:* mocha

# Node.js debugging
node --inspect-brk ./node_modules/.bin/mocha

# Chrome DevTools debugging
mocha --inspect-brk
```

### Common Error Messages
- **Error**: `ReferenceError: describe is not defined`
  **Cause**: Mocha not properly loaded in environment
  **Solution**: Ensure proper test runner setup

- **Error**: `Timeout of 2000ms exceeded`
  **Cause**: Test taking longer than default timeout
  **Solution**: Increase timeout or optimize test performance

- **Error**: `Cannot read property 'should' of undefined`
  **Cause**: Chai 'should' style not properly initialized
  **Solution**: Call `chai.should()` before using should assertions
````
