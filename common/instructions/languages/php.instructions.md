---
applyTo: "**/*.php,**/*.phtml"
---

# PHP Coding & Style Guide (with AI Linting Hints)

This guide defines coding standards and best practices for PHP development. These include AI linting hints to automatically enforce style rules and maintain clean, performant, and secure PHP code.

⸻

📂 Project Architecture

✅ Rule: Enforce API-first architecture

- Backend (PHP) must provide API logic and return JSON only. No HTML rendering in API endpoints.
- Frontend must consume API data and render UI. Strict separation between data and presentation layers.

✅ Rule: Strict separation of concerns

- PHP → API endpoints, business logic, and data processing
- HTML → Structural markup only (no embedded PHP logic)
- CSS → External stylesheets only
- JavaScript → External scripts only

✅ Rule: Namespaces and Autoloading

- Organize PHP into namespaces following PSR-4 standards
- Use Composer autoloading to avoid require/include calls
- Follow directory structure matching namespace hierarchy

✅ Rule: Configuration Management

- Use environment variables for configuration (database, API keys)
- Separate development, staging, and production configs
- Never commit sensitive configuration to version control

✅ Rule: Variable Functions & Classes

- Use variable functions/classes instead of many case statements or logical evaluations
- Implement consistent patterns for flexibility and reduced code changes

⸻

📜 Standard Libraries & Frameworks

✅ Rule: Prefer modern PHP features

- Use PHP 8.0+ features (union types, named arguments, attributes)
- Leverage built-in functions over custom implementations
- Use `filter_var()` for input validation
- Use `password_hash()` and `password_verify()` for passwords

✅ Rule: Approved frameworks and libraries

- **Frameworks**: Laravel, Symfony, CodeIgniter for structured applications
- **Database**: PDO with prepared statements, Eloquent ORM
- **HTTP**: Guzzle for API calls, cURL for simple requests
- **Validation**: Respect/Validation, Laravel Validator
- **Testing**: PHPUnit for unit testing

✅ Rule: Composer Dependency Management

- Use `composer.json` for all dependencies
- Pin versions for production stability
- Separate require and require-dev dependencies
- Regular security updates with `composer audit`

⸻

🖋 PHP Coding Standards

✅ String Handling

- Use single quotes (' ') unless variable interpolation or escape sequences require double quotes
- Concatenate variables using '.' rather than embedding in double quotes
- Define constants for repeated strings and magic numbers

✅ Example:

```php
<?php
define('NL', "\n");
const API_VERSION = 'v1';

$username = 'john_doe';
echo 'Hello, ' . $username . '!' . NL;
```

⸻

✅ Output

- Avoid multiple echo calls on adjacent lines. Combine output using '.' and newline constants
- Use output buffering for complex output generation
- Return data from functions instead of echoing directly

❌ Bad:

```php
echo 'Line 1';
echo "\n";
echo 'Line 2';
```

✅ Good:

```php
echo 'Line 1' . NL . 'Line 2' . NL;

// Or for complex output
$output = implode(NL, [
    'Line 1',
    'Line 2',
    'Line 3'
]);
echo $output;
```

⸻

✅ Loops & Memory (PHP)

- Cache function results at the top of loops if reused multiple times
- 🚫 Avoid string accumulation inside loops:
  - Do not use `.=` concatenation in loops
  - Do not use `$array[] = 'string'` for building strings

❌ Bad:

```php
$output = '';
foreach ($lines as $line) {
    $output .= $line; // prohibited
}

// Also bad - array accumulation for strings
$parts = [];
foreach ($lines as $line) {
    $parts[] = $line; // prohibited string accumulation
}
$result = implode('', $parts);
```

✅ Good:

```php
$output = implode(NL, $lines);

// For complex transformations
$output = implode(NL, array_map('trim', $lines));
```

⸻

✅ Variable Functions (PHP)

- Use variable functions instead of switch/case statements when appropriate
- Follow Node-RED pattern: single $msg argument, return modified $msg['payload']
- Simplifies code and reduces maintenance overhead

✅ Example:

```php
// Bad: Multiple case statements
function processAction($action, $data) {
    switch ($action) {
        case 'validate':
            return validateData($data);
        case 'transform':
            return transformData($data);
        case 'save':
            return saveData($data);
        default:
            throw new InvalidArgumentException("Unknown action: $action");
    }
}

// Good: Variable function pattern
function processMessage($msg) {
    $functionName = $msg['action'] . '_handler';
    if (function_exists($functionName)) {
        return $functionName($msg);
    }
    throw new InvalidArgumentException("Handler not found: $functionName");
}

function validate_handler($msg) {
    // Process validation
    $msg['payload'] = validateData($msg['payload']);
    return $msg;
}

function transform_handler($msg) {
    // Process transformation
    $msg['payload'] = transformData($msg['payload']);
    return $msg;
}
```

✅ Variable Classes (PHP)

- Implement consistent class interface: constructor, destructor, get, set, main
- Use internal data object for state management
- Enable dynamic class instantiation

✅ Example:

```php
abstract class BaseProcessor {
    protected $data = [];
    
    public function __construct($config = []) {
        $this->data = $config;
    }
    
    public function __destruct() {
        // Cleanup if needed
    }
    
    public function get($key) {
        return $this->data[$key] ?? null;
    }
    
    public function set($key, $value) {
        $this->data[$key] = $value;
        return $this;
    }
    
    public function main($msg) {
        // Main processing logic
        $msg['payload'] = $this->process($msg['payload']);
        return $msg;
    }
    
    abstract protected function process($payload);
}

// Usage with variable classes
$className = ucfirst($msg['processor']) . 'Processor';
if (class_exists($className)) {
    $processor = new $className($config);
    $result = $processor->main($msg);
}
```

⸻

✅ Error Handling & Security

- Use exceptions for error handling instead of error codes
- Validate and sanitize all input data
- Use prepared statements for database queries
- Implement proper session and CSRF protection

✅ Example:

```php
class ApiException extends Exception {
    private $httpCode;
    
    public function __construct($message, $httpCode = 400, $previous = null) {
        parent::__construct($message, 0, $previous);
        $this->httpCode = $httpCode;
    }
    
    public function getHttpCode() {
        return $this->httpCode;
    }
}

function validateUserInput($data) {
    $errors = [];
    
    if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'Invalid email format';
    }
    
    if (strlen($data['password']) < 8) {
        $errors[] = 'Password must be at least 8 characters';
    }
    
    if (!empty($errors)) {
        throw new ApiException('Validation failed: ' . implode(', ', $errors), 422);
    }
    
    return $data;
}

// Database query with prepared statements
function getUserById($pdo, $userId) {
    $stmt = $pdo->prepare('SELECT * FROM users WHERE id = :id');
    $stmt->bindParam(':id', $userId, PDO::PARAM_INT);
    $stmt->execute();
    
    return $stmt->fetch(PDO::FETCH_ASSOC);
}
```

⸻

✅ Type Declarations & Documentation

- Use strict types declaration at the top of files
- Implement type hints for function parameters and return values
- Write PHPDoc comments for complex functions and classes

✅ Example:

```php
<?php
declare(strict_types=1);

/**
 * Process user registration data
 *
 * @param array $userData User registration data
 * @param array $options Processing options
 * @return array Processed user data
 * @throws ApiException If validation fails
 */
function processUserRegistration(array $userData, array $options = []): array {
    $validatedData = validateUserInput($userData);
    
    return [
        'id' => generateUserId(),
        'email' => $validatedData['email'],
        'password_hash' => password_hash($validatedData['password'], PASSWORD_DEFAULT),
        'created_at' => date('Y-m-d H:i:s'),
        'options' => $options
    ];
}
```

⸻

🧠 Performance & Security

- Use PDO with prepared statements for all database queries
- Implement proper caching strategies (Redis, Memcached, APCu)
- Optimize autoloading and reduce file includes
- Use proper session management and HTTPS

✅ Example:

```php
class DatabaseManager {
    private $pdo;
    private $cache;
    
    public function __construct(PDO $pdo, $cache = null) {
        $this->pdo = $pdo;
        $this->cache = $cache;
    }
    
    public function getUserWithCache(int $userId): ?array {
        $cacheKey = "user:$userId";
        
        // Check cache first
        if ($this->cache) {
            $cached = $this->cache->get($cacheKey);
            if ($cached !== false) {
                return $cached;
            }
        }
        
        // Query database
        $stmt = $this->pdo->prepare('SELECT * FROM users WHERE id = :id');
        $stmt->execute(['id' => $userId]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        // Cache result
        if ($this->cache && $user) {
            $this->cache->set($cacheKey, $user, 3600); // 1 hour
        }
        
        return $user ?: null;
    }
}
```

⸻

🧪 Testing Standards

✅ Unit Testing with PHPUnit

- Write unit tests for all business logic
- Use meaningful test names that describe behavior
- Mock external dependencies and database calls
- Test both success and failure scenarios

✅ Example:

```php
<?php
use PHPUnit\Framework\TestCase;

class UserProcessorTest extends TestCase {
    
    public function testProcessUserRegistrationWithValidData(): void {
        // Arrange
        $userData = [
            'email' => 'test@example.com',
            'password' => 'securepassword123'
        ];
        
        // Act
        $result = processUserRegistration($userData);
        
        // Assert
        $this->assertIsArray($result);
        $this->assertEquals('test@example.com', $result['email']);
        $this->assertArrayHasKey('password_hash', $result);
        $this->assertTrue(password_verify('securepassword123', $result['password_hash']));
    }
    
    public function testProcessUserRegistrationThrowsExceptionForInvalidEmail(): void {
        // Arrange
        $userData = [
            'email' => 'invalid-email',
            'password' => 'securepassword123'
        ];
        
        // Act & Assert
        $this->expectException(ApiException::class);
        $this->expectExceptionMessage('Invalid email format');
        
        processUserRegistration($userData);
    }
}
```

⸻

⚡ Performance Rules

✅ PHP-Specific Optimization

- 🚫 Avoid string concatenation inside loops using `.=`
- 🚫 Avoid array building for simple string operations
- ✅ Use `implode()` and `explode()` for string operations
- ✅ Cache expensive operations outside loops
- ✅ Use prepared statements for database queries
- ✅ Implement proper caching strategies

⸻

✍️ Commit Message Conventions

- Prefix commits with: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`
- Example: `feat: add user authentication with JWT tokens`

⸻

🚦 AI Enforcement Summary

✅ Enforce API-first architecture separation
✅ Block string concatenation in loops (`.=`)
✅ Block array-based string accumulation for simple operations
✅ Require strict types declaration
✅ Enforce prepared statements for database queries
✅ Require input validation and sanitization
✅ Prefer variable functions/classes over switch statements
✅ Enforce consistent class interfaces (constructor, get, set, main)
✅ Require PHPDoc documentation for public methods
✅ Enforce PSR-4 autoloading and namespace usage
✅ Auto-fix PSR-12 coding style violations where possible
