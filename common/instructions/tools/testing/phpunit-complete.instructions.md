# PHPUnit Testing Framework Instructions

## Tool Overview

- **Tool Name**: PHPUnit
- **Version**: 10.5+ (stable), 11.0+ (latest with enhanced features)
- **Category**: Testing Tools
- **Purpose**: Comprehensive PHP testing framework for unit, integration, and functional testing
- **Prerequisites**: PHP 8.1+ (8.2+ recommended), Composer

## Installation & Setup

### Composer Installation

```bash
# Install as dev dependency (recommended)
composer require --dev phpunit/phpunit

# Install globally
composer global require phpunit/phpunit

# Install specific version
composer require --dev phpunit/phpunit:^10.5

# With additional testing utilities
composer require --dev phpunit/phpunit
composer require --dev mockery/mockery
composer require --dev fakerphp/faker
composer require --dev phpstan/phpstan
composer require --dev friendsofphp/php-cs-fixer

# For database testing
composer require --dev phpunit/dbunit
composer require --dev symfony/var-dumper
```

### Project Initialization

```bash
# Generate phpunit.xml configuration
vendor/bin/phpunit --generate-configuration

# Create basic test directory structure
mkdir -p tests/{Unit,Integration,Feature}
mkdir -p tests/fixtures

# Run tests
vendor/bin/phpunit

# Run with coverage
vendor/bin/phpunit --coverage-html coverage/

# Run specific test
vendor/bin/phpunit tests/Unit/UserTest.php

# Run with filters
vendor/bin/phpunit --filter testUserCreation
vendor/bin/phpunit --group integration
```

### Configuration Setup

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- phpunit.xml -->
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="https://schema.phpunit.de/10.5/phpunit.xsd"
         bootstrap="vendor/autoload.php"
         cacheDirectory=".phpunit.cache"
         executionOrder="depends,defects"
         requireCoverageMetadata="true"
         beStrictAboutCoverageMetadata="true"
         beStrictAboutOutputDuringTests="true"
         colors="true"
         failOnRisky="true"
         failOnWarning="true"
         stopOnFailure="false">

    <!-- Test Suites -->
    <testsuites>
        <testsuite name="Unit">
            <directory>tests/Unit</directory>
        </testsuite>
        <testsuite name="Integration">
            <directory>tests/Integration</directory>
        </testsuite>
        <testsuite name="Feature">
            <directory>tests/Feature</directory>
        </testsuite>
    </testsuites>

    <!-- Source code for coverage -->
    <source>
        <include>
            <directory>src</directory>
        </include>
        <exclude>
            <directory>src/migrations</directory>
            <file>src/bootstrap.php</file>
        </exclude>
    </source>

    <!-- Coverage reporting -->
    <coverage>
        <report>
            <html outputDirectory="coverage/html"/>
            <clover outputFile="coverage/clover.xml"/>
            <cobertura outputFile="coverage/cobertura.xml"/>
            <text outputFile="php://stdout" showUncoveredFiles="false"/>
        </report>
    </coverage>

    <!-- Environment variables -->
    <php>
        <env name="APP_ENV" value="testing"/>
        <env name="DB_CONNECTION" value="sqlite"/>
        <env name="DB_DATABASE" value=":memory:"/>
        <env name="CACHE_DRIVER" value="array"/>
        <env name="SESSION_DRIVER" value="array"/>
        <env name="QUEUE_CONNECTION" value="sync"/>
        <ini name="display_errors" value="1"/>
        <ini name="memory_limit" value="512M"/>
    </php>

    <!-- Extensions and listeners -->
    <extensions>
        <bootstrap class="App\Tests\Bootstrap\TestBootstrap"/>
    </extensions>

    <!-- Logging -->
    <logging>
        <junit outputFile="reports/junit.xml"/>
        <testdoxHtml outputFile="reports/testdox.html"/>
        <testdoxText outputFile="reports/testdox.txt"/>
    </logging>
</phpunit>
```

### Bootstrap Configuration

```php
<?php
// tests/bootstrap.php
require_once __DIR__ . '/../vendor/autoload.php';

// Load environment variables
if (file_exists(__DIR__ . '/../.env.testing')) {
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../', '.env.testing');
    $dotenv->load();
}

// Initialize test database
if (!defined('DB_TEST_INITIALIZED')) {
    // Create test database schema
    require_once __DIR__ . '/database/TestDatabaseSetup.php';
    define('DB_TEST_INITIALIZED', true);
}

// Set up global test configuration
date_default_timezone_set('UTC');
ini_set('memory_limit', '512M');
```

## Core Testing Patterns

### Basic Unit Test Structure

```php
<?php
// tests/Unit/UserTest.php
namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\Attributes\Group;
use App\Models\User;
use App\Exceptions\InvalidEmailException;

class UserTest extends TestCase
{
    private User $user;

    protected function setUp(): void
    {
        parent::setUp();
        $this->user = new User();
    }

    protected function tearDown(): void
    {
        // Cleanup after each test
        parent::tearDown();
    }

    #[Test]
    public function it_creates_user_with_valid_data(): void
    {
        // Arrange
        $userData = [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123'
        ];

        // Act
        $user = new User($userData);

        // Assert
        $this->assertEquals('John Doe', $user->getName());
        $this->assertEquals('john@example.com', $user->getEmail());
        $this->assertTrue($user->verifyPassword('password123'));
        $this->assertInstanceOf(User::class, $user);
    }

    #[Test]
    public function it_throws_exception_for_invalid_email(): void
    {
        // Arrange & Assert
        $this->expectException(InvalidEmailException::class);
        $this->expectExceptionMessage('Invalid email format');

        // Act
        new User([
            'name' => 'John Doe',
            'email' => 'invalid-email',
            'password' => 'password123'
        ]);
    }

    #[Test]
    #[DataProvider('invalidUserDataProvider')]
    public function it_validates_user_data(array $invalidData, string $expectedError): void
    {
        $this->expectException(\InvalidArgumentException::class);
        $this->expectExceptionMessage($expectedError);

        new User($invalidData);
    }

    public static function invalidUserDataProvider(): array
    {
        return [
            'empty name' => [
                ['name' => '', 'email' => 'john@example.com', 'password' => 'pass123'],
                'Name cannot be empty'
            ],
            'short password' => [
                ['name' => 'John', 'email' => 'john@example.com', 'password' => '123'],
                'Password must be at least 6 characters'
            ],
            'invalid email' => [
                ['name' => 'John', 'email' => 'invalid', 'password' => 'pass123'],
                'Invalid email format'
            ]
        ];
    }

    #[Test]
    #[Group('security')]
    public function it_hashes_password_on_creation(): void
    {
        $user = new User([
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123'
        ]);

        $this->assertNotEquals('password123', $user->getHashedPassword());
        $this->assertTrue(password_verify('password123', $user->getHashedPassword()));
    }

    #[Test]
    public function it_generates_unique_id(): void
    {
        $user1 = new User(['name' => 'User 1', 'email' => 'user1@example.com', 'password' => 'pass123']);
        $user2 = new User(['name' => 'User 2', 'email' => 'user2@example.com', 'password' => 'pass123']);

        $this->assertNotEquals($user1->getId(), $user2->getId());
        $this->assertIsString($user1->getId());
        $this->assertNotEmpty($user1->getId());
    }
}
```

### Mocking and Stubbing

```php
<?php
// tests/Unit/UserServiceTest.php
namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\MockObject\MockObject;
use PHPUnit\Framework\Attributes\Test;
use App\Services\UserService;
use App\Repositories\UserRepository;
use App\Services\EmailService;
use App\Models\User;

class UserServiceTest extends TestCase
{
    private UserService $userService;
    private MockObject $userRepository;
    private MockObject $emailService;

    protected function setUp(): void
    {
        parent::setUp();

        // Create mocks
        $this->userRepository = $this->createMock(UserRepository::class);
        $this->emailService = $this->createMock(EmailService::class);

        // Inject dependencies
        $this->userService = new UserService(
            $this->userRepository,
            $this->emailService
        );
    }

    #[Test]
    public function it_creates_user_and_sends_welcome_email(): void
    {
        // Arrange
        $userData = [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123'
        ];

        $expectedUser = new User($userData);

        // Mock repository behavior
        $this->userRepository
            ->expects($this->once())
            ->method('save')
            ->with($this->isInstanceOf(User::class))
            ->willReturn($expectedUser);

        // Mock email service behavior
        $this->emailService
            ->expects($this->once())
            ->method('sendWelcomeEmail')
            ->with($this->equalTo($expectedUser))
            ->willReturn(true);

        // Act
        $result = $this->userService->createUser($userData);

        // Assert
        $this->assertInstanceOf(User::class, $result);
        $this->assertEquals('john@example.com', $result->getEmail());
    }

    #[Test]
    public function it_handles_email_service_failure(): void
    {
        // Arrange
        $userData = ['name' => 'John', 'email' => 'john@example.com', 'password' => 'pass123'];
        $user = new User($userData);

        $this->userRepository
            ->method('save')
            ->willReturn($user);

        // Mock email service failure
        $this->emailService
            ->method('sendWelcomeEmail')
            ->willThrowException(new \RuntimeException('Email service unavailable'));

        // Act & Assert
        $this->expectException(\RuntimeException::class);
        $this->expectExceptionMessage('Email service unavailable');

        $this->userService->createUser($userData);
    }

    #[Test]
    public function it_finds_user_by_email(): void
    {
        // Arrange
        $email = 'john@example.com';
        $expectedUser = new User(['name' => 'John', 'email' => $email, 'password' => 'pass123']);

        $this->userRepository
            ->expects($this->once())
            ->method('findByEmail')
            ->with($this->equalTo($email))
            ->willReturn($expectedUser);

        // Act
        $result = $this->userService->findUserByEmail($email);

        // Assert
        $this->assertSame($expectedUser, $result);
    }

    #[Test]
    public function it_returns_null_when_user_not_found(): void
    {
        // Arrange
        $email = 'nonexistent@example.com';

        $this->userRepository
            ->method('findByEmail')
            ->with($email)
            ->willReturn(null);

        // Act
        $result = $this->userService->findUserByEmail($email);

        // Assert
        $this->assertNull($result);
    }
}
```

### Advanced Mocking with Mockery

```php
<?php
// tests/Unit/PaymentServiceTest.php
namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use Mockery;
use Mockery\Adapter\Phpunit\MockeryPHPUnitIntegration;
use App\Services\PaymentService;
use App\Gateways\PaymentGateway;
use App\Models\Payment;

class PaymentServiceTest extends TestCase
{
    use MockeryPHPUnitIntegration; // Ensures Mockery assertions are run

    private PaymentService $paymentService;
    private $paymentGateway;

    protected function setUp(): void
    {
        parent::setUp();

        $this->paymentGateway = Mockery::mock(PaymentGateway::class);
        $this->paymentService = new PaymentService($this->paymentGateway);
    }

    #[Test]
    public function it_processes_payment_successfully(): void
    {
        // Arrange
        $paymentData = [
            'amount' => 100.00,
            'currency' => 'USD',
            'card_token' => 'tok_12345'
        ];

        $this->paymentGateway
            ->shouldReceive('charge')
            ->once()
            ->with(100.00, 'USD', 'tok_12345')
            ->andReturn([
                'id' => 'ch_12345',
                'status' => 'succeeded',
                'amount' => 100.00
            ]);

        // Act
        $result = $this->paymentService->processPayment($paymentData);

        // Assert
        $this->assertInstanceOf(Payment::class, $result);
        $this->assertEquals('succeeded', $result->getStatus());
        $this->assertEquals(100.00, $result->getAmount());
    }

    #[Test]
    public function it_handles_payment_failure(): void
    {
        // Arrange
        $paymentData = [
            'amount' => 100.00,
            'currency' => 'USD',
            'card_token' => 'tok_invalid'
        ];

        $this->paymentGateway
            ->shouldReceive('charge')
            ->once()
            ->andThrow(new \App\Exceptions\PaymentException('Card declined'));

        // Act & Assert
        $this->expectException(\App\Exceptions\PaymentException::class);
        $this->expectExceptionMessage('Card declined');

        $this->paymentService->processPayment($paymentData);
    }

    #[Test]
    public function it_validates_payment_amount(): void
    {
        // Test with negative amount
        $this->paymentGateway->shouldNotReceive('charge');

        $this->expectException(\InvalidArgumentException::class);
        $this->expectExceptionMessage('Amount must be positive');

        $this->paymentService->processPayment([
            'amount' => -10.00,
            'currency' => 'USD',
            'card_token' => 'tok_12345'
        ]);
    }
}
```

## Database Testing

### Database Test Setup

```php
<?php
// tests/Integration/UserRepositoryTest.php
namespace Tests\Integration;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;
use App\Repositories\UserRepository;
use App\Models\User;
use PDO;

class UserRepositoryTest extends TestCase
{
    private PDO $pdo;
    private UserRepository $userRepository;

    protected function setUp(): void
    {
        parent::setUp();

        // Create in-memory SQLite database
        $this->pdo = new PDO('sqlite::memory:');
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // Create tables
        $this->createTables();

        // Initialize repository
        $this->userRepository = new UserRepository($this->pdo);
    }

    protected function tearDown(): void
    {
        $this->pdo = null;
        parent::tearDown();
    }

    private function createTables(): void
    {
        $sql = "
            CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR(255) NOT NULL,
                email VARCHAR(255) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        ";

        $this->pdo->exec($sql);
    }

    #[Test]
    public function it_saves_user_to_database(): void
    {
        // Arrange
        $user = new User([
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123'
        ]);

        // Act
        $savedUser = $this->userRepository->save($user);

        // Assert
        $this->assertNotNull($savedUser->getId());
        $this->assertEquals('John Doe', $savedUser->getName());
        $this->assertEquals('john@example.com', $savedUser->getEmail());

        // Verify in database
        $stmt = $this->pdo->prepare('SELECT * FROM users WHERE email = ?');
        $stmt->execute(['john@example.com']);
        $dbUser = $stmt->fetch(PDO::FETCH_ASSOC);

        $this->assertNotFalse($dbUser);
        $this->assertEquals('John Doe', $dbUser['name']);
    }

    #[Test]
    public function it_finds_user_by_email(): void
    {
        // Arrange - Insert test data
        $stmt = $this->pdo->prepare('
            INSERT INTO users (name, email, password)
            VALUES (?, ?, ?)
        ');
        $stmt->execute(['Jane Doe', 'jane@example.com', password_hash('pass123', PASSWORD_DEFAULT)]);

        // Act
        $user = $this->userRepository->findByEmail('jane@example.com');

        // Assert
        $this->assertInstanceOf(User::class, $user);
        $this->assertEquals('Jane Doe', $user->getName());
        $this->assertEquals('jane@example.com', $user->getEmail());
    }

    #[Test]
    public function it_returns_null_for_nonexistent_email(): void
    {
        // Act
        $user = $this->userRepository->findByEmail('nonexistent@example.com');

        // Assert
        $this->assertNull($user);
    }

    #[Test]
    public function it_updates_existing_user(): void
    {
        // Arrange - Create and save user
        $user = new User([
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123'
        ]);
        $savedUser = $this->userRepository->save($user);

        // Act - Update user
        $savedUser->setName('John Updated');
        $updatedUser = $this->userRepository->save($savedUser);

        // Assert
        $this->assertEquals('John Updated', $updatedUser->getName());
        $this->assertEquals($savedUser->getId(), $updatedUser->getId());

        // Verify in database
        $stmt = $this->pdo->prepare('SELECT name FROM users WHERE id = ?');
        $stmt->execute([$updatedUser->getId()]);
        $name = $stmt->fetchColumn();

        $this->assertEquals('John Updated', $name);
    }
}
```

### Database Transactions and Fixtures

```php
<?php
// tests/Integration/DatabaseTestCase.php
namespace Tests\Integration;

use PHPUnit\Framework\TestCase;
use PDO;

abstract class DatabaseTestCase extends TestCase
{
    protected PDO $pdo;

    protected function setUp(): void
    {
        parent::setUp();

        $this->pdo = $this->createTestDatabase();
        $this->pdo->beginTransaction();
    }

    protected function tearDown(): void
    {
        if ($this->pdo->inTransaction()) {
            $this->pdo->rollBack();
        }

        parent::tearDown();
    }

    private function createTestDatabase(): PDO
    {
        $pdo = new PDO('sqlite::memory:');
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // Load schema
        $schema = file_get_contents(__DIR__ . '/../fixtures/schema.sql');
        $pdo->exec($schema);

        return $pdo;
    }

    protected function loadFixtures(array $fixtures): void
    {
        foreach ($fixtures as $table => $data) {
            $this->loadFixtureData($table, $data);
        }
    }

    private function loadFixtureData(string $table, array $data): void
    {
        if (empty($data)) {
            return;
        }

        $columns = array_keys($data[0]);
        $placeholders = str_repeat('?,', count($columns) - 1) . '?';

        $sql = "INSERT INTO {$table} (" . implode(',', $columns) . ") VALUES ({$placeholders})";
        $stmt = $this->pdo->prepare($sql);

        foreach ($data as $row) {
            $stmt->execute(array_values($row));
        }
    }

    protected function assertDatabaseHas(string $table, array $conditions): void
    {
        $where = [];
        $values = [];

        foreach ($conditions as $column => $value) {
            $where[] = "{$column} = ?";
            $values[] = $value;
        }

        $sql = "SELECT COUNT(*) FROM {$table} WHERE " . implode(' AND ', $where);
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($values);

        $count = $stmt->fetchColumn();
        $this->assertGreaterThan(0, $count, "Failed asserting that table '{$table}' contains matching record.");
    }

    protected function assertDatabaseMissing(string $table, array $conditions): void
    {
        $where = [];
        $values = [];

        foreach ($conditions as $column => $value) {
            $where[] = "{$column} = ?";
            $values[] = $value;
        }

        $sql = "SELECT COUNT(*) FROM {$table} WHERE " . implode(' AND ', $where);
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($values);

        $count = $stmt->fetchColumn();
        $this->assertEquals(0, $count, "Failed asserting that table '{$table}' does not contain matching record.");
    }
}
```

## Feature Testing

### HTTP Testing

```php
<?php
// tests/Feature/UserApiTest.php
namespace Tests\Feature;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;
use GuzzleHttp\Client;
use GuzzleHttp\Psr7\Response;
use GuzzleHttp\Exception\ClientException;

class UserApiTest extends TestCase
{
    private Client $client;
    private string $baseUrl;

    protected function setUp(): void
    {
        parent::setUp();

        $this->baseUrl = 'http://localhost:8080';
        $this->client = new Client([
            'base_uri' => $this->baseUrl,
            'timeout' => 10,
            'http_errors' => false // Don't throw on 4xx/5xx responses
        ]);
    }

    #[Test]
    public function it_creates_user_via_api(): void
    {
        // Arrange
        $userData = [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123'
        ];

        // Act
        $response = $this->client->post('/api/users', [
            'json' => $userData,
            'headers' => [
                'Content-Type' => 'application/json',
                'Accept' => 'application/json'
            ]
        ]);

        // Assert
        $this->assertEquals(201, $response->getStatusCode());

        $responseData = json_decode($response->getBody()->getContents(), true);
        $this->assertArrayHasKey('id', $responseData);
        $this->assertEquals('John Doe', $responseData['name']);
        $this->assertEquals('john@example.com', $responseData['email']);
        $this->assertArrayNotHasKey('password', $responseData); // Password should not be returned
    }

    #[Test]
    public function it_validates_required_fields(): void
    {
        // Act
        $response = $this->client->post('/api/users', [
            'json' => ['name' => 'John Doe'], // Missing email and password
            'headers' => ['Content-Type' => 'application/json']
        ]);

        // Assert
        $this->assertEquals(422, $response->getStatusCode());

        $responseData = json_decode($response->getBody()->getContents(), true);
        $this->assertArrayHasKey('errors', $responseData);
        $this->assertArrayHasKey('email', $responseData['errors']);
        $this->assertArrayHasKey('password', $responseData['errors']);
    }

    #[Test]
    public function it_retrieves_user_by_id(): void
    {
        // Arrange - Create user first
        $createResponse = $this->client->post('/api/users', [
            'json' => [
                'name' => 'Jane Doe',
                'email' => 'jane@example.com',
                'password' => 'password123'
            ]
        ]);

        $userData = json_decode($createResponse->getBody()->getContents(), true);
        $userId = $userData['id'];

        // Act
        $response = $this->client->get("/api/users/{$userId}");

        // Assert
        $this->assertEquals(200, $response->getStatusCode());

        $responseData = json_decode($response->getBody()->getContents(), true);
        $this->assertEquals($userId, $responseData['id']);
        $this->assertEquals('Jane Doe', $responseData['name']);
    }

    #[Test]
    public function it_returns_404_for_nonexistent_user(): void
    {
        // Act
        $response = $this->client->get('/api/users/99999');

        // Assert
        $this->assertEquals(404, $response->getStatusCode());

        $responseData = json_decode($response->getBody()->getContents(), true);
        $this->assertArrayHasKey('error', $responseData);
        $this->assertEquals('User not found', $responseData['error']);
    }

    #[Test]
    public function it_handles_authentication(): void
    {
        // Act - Try to access protected endpoint without auth
        $response = $this->client->get('/api/users/profile');

        // Assert
        $this->assertEquals(401, $response->getStatusCode());

        // Test with valid token
        $token = $this->authenticate();
        $response = $this->client->get('/api/users/profile', [
            'headers' => ['Authorization' => "Bearer {$token}"]
        ]);

        $this->assertEquals(200, $response->getStatusCode());
    }

    private function authenticate(): string
    {
        $response = $this->client->post('/api/auth/login', [
            'json' => [
                'email' => 'test@example.com',
                'password' => 'password123'
            ]
        ]);

        $data = json_decode($response->getBody()->getContents(), true);
        return $data['token'];
    }
}
```

### File Upload Testing

```php
<?php
// tests/Feature/FileUploadTest.php
namespace Tests\Feature;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;
use GuzzleHttp\Client;
use GuzzleHttp\Psr7\Utils;

class FileUploadTest extends TestCase
{
    private Client $client;

    protected function setUp(): void
    {
        parent::setUp();
        $this->client = new Client(['base_uri' => 'http://localhost:8080']);
    }

    #[Test]
    public function it_uploads_valid_image(): void
    {
        // Arrange - Create test image
        $testImagePath = $this->createTestImage();

        // Act
        $response = $this->client->post('/api/upload', [
            'multipart' => [
                [
                    'name' => 'file',
                    'contents' => Utils::tryFopen($testImagePath, 'r'),
                    'filename' => 'test-image.jpg'
                ],
                [
                    'name' => 'type',
                    'contents' => 'avatar'
                ]
            ]
        ]);

        // Assert
        $this->assertEquals(200, $response->getStatusCode());

        $responseData = json_decode($response->getBody()->getContents(), true);
        $this->assertArrayHasKey('url', $responseData);
        $this->assertArrayHasKey('size', $responseData);
        $this->assertStringContainsString('.jpg', $responseData['url']);

        // Cleanup
        unlink($testImagePath);
    }

    #[Test]
    public function it_rejects_invalid_file_types(): void
    {
        // Arrange - Create test file with invalid extension
        $testFilePath = tempnam(sys_get_temp_dir(), 'test') . '.exe';
        file_put_contents($testFilePath, 'fake executable content');

        // Act
        $response = $this->client->post('/api/upload', [
            'multipart' => [
                [
                    'name' => 'file',
                    'contents' => Utils::tryFopen($testFilePath, 'r'),
                    'filename' => 'malicious.exe'
                ]
            ],
            'http_errors' => false
        ]);

        // Assert
        $this->assertEquals(422, $response->getStatusCode());

        $responseData = json_decode($response->getBody()->getContents(), true);
        $this->assertArrayHasKey('error', $responseData);
        $this->assertStringContainsString('file type', $responseData['error']);

        // Cleanup
        unlink($testFilePath);
    }

    private function createTestImage(): string
    {
        $imagePath = tempnam(sys_get_temp_dir(), 'test_image') . '.jpg';

        // Create a simple 100x100 red image
        $image = imagecreate(100, 100);
        $red = imagecolorallocate($image, 255, 0, 0);
        imagefill($image, 0, 0, $red);
        imagejpeg($image, $imagePath);
        imagedestroy($image);

        return $imagePath;
    }
}
```

## Advanced Testing Techniques

### Test Doubles and Factories

```php
<?php
// tests/Factories/UserFactory.php
namespace Tests\Factories;

use App\Models\User;
use Faker\Factory as FakerFactory;

class UserFactory
{
    private static $faker;

    public static function create(array $overrides = []): User
    {
        if (!self::$faker) {
            self::$faker = FakerFactory::create();
        }

        $defaults = [
            'name' => self::$faker->name,
            'email' => self::$faker->unique()->safeEmail,
            'password' => 'password123',
            'age' => self::$faker->numberBetween(18, 80),
            'country' => self::$faker->country
        ];

        $data = array_merge($defaults, $overrides);
        return new User($data);
    }

    public static function createMany(int $count, array $overrides = []): array
    {
        $users = [];
        for ($i = 0; $i < $count; $i++) {
            $users[] = self::create($overrides);
        }
        return $users;
    }

    public static function admin(array $overrides = []): User
    {
        return self::create(array_merge(['role' => 'admin'], $overrides));
    }

    public static function withEmail(string $email): User
    {
        return self::create(['email' => $email]);
    }
}
```

### Custom Assertions

```php
<?php
// tests/Assertions/CustomAssertions.php
namespace Tests\Assertions;

trait CustomAssertions
{
    protected function assertValidEmail(string $email): void
    {
        $this->assertTrue(
            filter_var($email, FILTER_VALIDATE_EMAIL) !== false,
            "Failed asserting that '{$email}' is a valid email address."
        );
    }

    protected function assertValidUuid(string $uuid): void
    {
        $pattern = '/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i';
        $this->assertMatchesRegularExpression(
            $pattern,
            $uuid,
            "Failed asserting that '{$uuid}' is a valid UUID."
        );
    }

    protected function assertJsonStructure(array $structure, string $json): void
    {
        $data = json_decode($json, true);
        $this->assertNotNull($data, 'Invalid JSON provided');

        $this->assertArrayStructure($structure, $data);
    }

    private function assertArrayStructure(array $structure, array $data): void
    {
        foreach ($structure as $key => $value) {
            if (is_array($value)) {
                $this->assertArrayHasKey($key, $data);
                $this->assertArrayStructure($value, $data[$key]);
            } else {
                $this->assertArrayHasKey($value, $data);
            }
        }
    }

    protected function assertApiResponse(array $expectedStructure, $response): void
    {
        $this->assertEquals(200, $response->getStatusCode());
        $this->assertJsonStructure($expectedStructure, $response->getBody()->getContents());
    }

    protected function assertValidationError(array $expectedFields, $response): void
    {
        $this->assertEquals(422, $response->getStatusCode());

        $data = json_decode($response->getBody()->getContents(), true);
        $this->assertArrayHasKey('errors', $data);

        foreach ($expectedFields as $field) {
            $this->assertArrayHasKey($field, $data['errors']);
        }
    }
}
```

### Performance Testing

```php
<?php
// tests/Performance/UserServicePerformanceTest.php
namespace Tests\Performance;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\Attributes\Group;
use App\Services\UserService;
use Tests\Factories\UserFactory;

#[Group('performance')]
class UserServicePerformanceTest extends TestCase
{
    private UserService $userService;

    protected function setUp(): void
    {
        parent::setUp();
        $this->userService = new UserService();
    }

    #[Test]
    public function it_creates_users_within_performance_limit(): void
    {
        $startTime = microtime(true);
        $memoryStart = memory_get_usage();

        // Create 1000 users
        for ($i = 0; $i < 1000; $i++) {
            $this->userService->createUser([
                'name' => "User {$i}",
                'email' => "user{$i}@example.com",
                'password' => 'password123'
            ]);
        }

        $executionTime = microtime(true) - $startTime;
        $memoryUsed = memory_get_usage() - $memoryStart;

        // Assertions
        $this->assertLessThan(5.0, $executionTime, 'User creation took too long');
        $this->assertLessThan(50 * 1024 * 1024, $memoryUsed, 'Memory usage too high'); // 50MB limit

        echo "\nPerformance metrics:\n";
        echo "Execution time: " . round($executionTime, 3) . " seconds\n";
        echo "Memory used: " . round($memoryUsed / 1024 / 1024, 2) . " MB\n";
    }

    #[Test]
    public function it_handles_concurrent_operations(): void
    {
        $startTime = microtime(true);

        // Simulate concurrent operations
        $processes = [];
        for ($i = 0; $i < 10; $i++) {
            $processes[] = $this->simulateConcurrentUserCreation($i * 100, 100);
        }

        // Wait for all processes to complete
        foreach ($processes as $process) {
            $process->wait();
        }

        $executionTime = microtime(true) - $startTime;

        $this->assertLessThan(10.0, $executionTime, 'Concurrent operations took too long');
    }

    private function simulateConcurrentUserCreation(int $start, int $count): object
    {
        // This would be implemented with actual process forking or threading
        // For demonstration purposes, we'll simulate it
        return new class($start, $count, $this->userService) {
            private int $start;
            private int $count;
            private UserService $userService;

            public function __construct(int $start, int $count, UserService $userService)
            {
                $this->start = $start;
                $this->count = $count;
                $this->userService = $userService;
            }

            public function wait(): void
            {
                for ($i = $this->start; $i < $this->start + $this->count; $i++) {
                    $this->userService->createUser([
                        'name' => "Concurrent User {$i}",
                        'email' => "concurrent{$i}@example.com",
                        'password' => 'password123'
                    ]);
                }
            }
        };
    }
}
```

## CI/CD Integration

### GitHub Actions Configuration

```yaml
# .github/workflows/phpunit.yml
name: PHPUnit Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        php-version: ['8.1', '8.2', '8.3']
        dependencies: ['lowest', 'highest']

    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: test_db
        ports:
          - 3306:3306
        options: --health-cmd="mysqladmin ping" --health-interval=10s --health-timeout=5s --health-retries=3

      redis:
        image: redis:7-alpine
        ports:
          - 6379:6379
        options: --health-cmd="redis-cli ping" --health-interval=10s --health-timeout=5s --health-retries=3

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: ${{ matrix.php-version }}
          extensions: mbstring, xml, ctype, iconv, intl, pdo, pdo_mysql, dom, filter, gd, json
          coverage: xdebug
          ini-values: memory_limit=512M

      - name: Get Composer cache directory
        id: composer-cache
        run: echo "dir=$(composer config cache-files-dir)" >> $GITHUB_OUTPUT

      - name: Cache Composer packages
        uses: actions/cache@v4
        with:
          path: ${{ steps.composer-cache.outputs.dir }}
          key: ${{ runner.os }}-php-${{ matrix.php-version }}-${{ hashFiles('**/composer.lock') }}
          restore-keys: |
            ${{ runner.os }}-php-${{ matrix.php-version }}-

      - name: Install dependencies
        run: |
          if [[ "${{ matrix.dependencies }}" == "lowest" ]]; then
            composer update --prefer-lowest --no-interaction --no-progress
          else
            composer install --no-interaction --no-progress
          fi

      - name: Prepare environment
        run: |
          cp .env.testing.example .env.testing
          php artisan key:generate --env=testing
          php artisan migrate --env=testing --force

      - name: Run coding standards
        run: vendor/bin/php-cs-fixer fix --dry-run --diff

      - name: Run static analysis
        run: vendor/bin/phpstan analyse

      - name: Run unit tests
        run: vendor/bin/phpunit --testsuite=Unit

      - name: Run integration tests
        run: vendor/bin/phpunit --testsuite=Integration
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: test_db
          DB_USERNAME: root
          DB_PASSWORD: root
          REDIS_HOST: 127.0.0.1
          REDIS_PORT: 6379

      - name: Run feature tests
        run: vendor/bin/phpunit --testsuite=Feature --coverage-clover=coverage.xml
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: test_db
          DB_USERNAME: root
          DB_PASSWORD: root

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml
          flags: phpunit
          name: PHP ${{ matrix.php-version }}

      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: test-results-php-${{ matrix.php-version }}
          path: |
            reports/
            storage/logs/
```

### Docker Configuration

```dockerfile
# Dockerfile.testing
FROM php:8.2-cli-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    mysql-client

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Xdebug for coverage
RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Set working directory
WORKDIR /app

# Copy composer files
COPY composer.json composer.lock ./

# Install dependencies
RUN composer install --no-scripts --no-autoloader

# Copy application code
COPY . .

# Generate autoloader
RUN composer dump-autoload --optimize

# Create required directories
RUN mkdir -p storage/logs bootstrap/cache

# Set permissions
RUN chmod -R 755 storage bootstrap/cache

# Run tests
CMD ["vendor/bin/phpunit"]
```

### Package.json Scripts (for Laravel Mix or similar)

```json
{
  "scripts": {
    "test": "vendor/bin/phpunit",
    "test:unit": "vendor/bin/phpunit --testsuite=Unit",
    "test:integration": "vendor/bin/phpunit --testsuite=Integration",
    "test:feature": "vendor/bin/phpunit --testsuite=Feature",
    "test:coverage": "vendor/bin/phpunit --coverage-html coverage/",
    "test:coverage-text": "vendor/bin/phpunit --coverage-text",
    "test:filter": "vendor/bin/phpunit --filter",
    "test:group": "vendor/bin/phpunit --group",
    "test:watch": "vendor/bin/phpunit-watcher watch",
    "test:parallel": "vendor/bin/paratest",
    "cs:check": "vendor/bin/php-cs-fixer fix --dry-run --diff",
    "cs:fix": "vendor/bin/php-cs-fixer fix",
    "stan": "vendor/bin/phpstan analyse",
    "quality": "npm run cs:check && npm run stan && npm run test"
  }
}
```

## Testing Best Practices

### Test Organization and Naming

```php
<?php
// Good test class organization
namespace Tests\Unit\Services;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\Attributes\DataProvider;

class UserServiceTest extends TestCase
{
    // Test methods should describe behavior, not implementation
    #[Test]
    public function it_creates_user_with_valid_data(): void { }

    #[Test]
    public function it_throws_exception_when_email_already_exists(): void { }

    #[Test]
    public function it_sends_welcome_email_after_user_creation(): void { }

    // Group related tests
    #[Test]
    #[DataProvider('invalidEmailProvider')]
    public function it_validates_email_format(string $invalidEmail): void { }

    // Use descriptive data providers
    public static function invalidEmailProvider(): array
    {
        return [
            'missing at symbol' => ['invalid-email'],
            'missing domain' => ['test@'],
            'missing local part' => ['@example.com'],
            'special characters' => ['test<>@example.com']
        ];
    }
}
```

### Test Data Management

```php
<?php
// tests/Support/TestDataBuilder.php
namespace Tests\Support;

class TestDataBuilder
{
    public static function user(): UserBuilder
    {
        return new UserBuilder();
    }

    public static function product(): ProductBuilder
    {
        return new ProductBuilder();
    }
}

class UserBuilder
{
    private array $data = [
        'name' => 'Test User',
        'email' => 'test@example.com',
        'password' => 'password123'
    ];

    public function withName(string $name): self
    {
        $this->data['name'] = $name;
        return $this;
    }

    public function withEmail(string $email): self
    {
        $this->data['email'] = $email;
        return $this;
    }

    public function admin(): self
    {
        $this->data['role'] = 'admin';
        return $this;
    }

    public function build(): array
    {
        return $this->data;
    }

    public function create(): User
    {
        return new User($this->data);
    }
}
```

### Error Testing Patterns

```php
<?php
// Comprehensive error testing
class PaymentProcessorTest extends TestCase
{
    #[Test]
    public function it_handles_network_timeout(): void
    {
        $gateway = $this->createMock(PaymentGateway::class);
        $gateway->method('charge')
               ->willThrowException(new NetworkTimeoutException());

        $processor = new PaymentProcessor($gateway);

        $this->expectException(PaymentProcessingException::class);
        $this->expectExceptionMessage('Payment processing failed due to network timeout');

        $processor->processPayment(100.00, 'tok_123');
    }

    #[Test]
    public function it_retries_on_transient_failures(): void
    {
        $gateway = $this->createMock(PaymentGateway::class);
        $gateway->expects($this->exactly(3))
               ->method('charge')
               ->willReturnOnConsecutiveCalls(
                   $this->throwException(new TransientException()),
                   $this->throwException(new TransientException()),
                   ['id' => 'ch_123', 'status' => 'succeeded']
               );

        $processor = new PaymentProcessor($gateway);
        $result = $processor->processPayment(100.00, 'tok_123');

        $this->assertEquals('succeeded', $result['status']);
    }

    #[Test]
    public function it_stops_retrying_on_permanent_failures(): void
    {
        $gateway = $this->createMock(PaymentGateway::class);
        $gateway->expects($this->once())
               ->method('charge')
               ->willThrowException(new CardDeclinedException());

        $processor = new PaymentProcessor($gateway);

        $this->expectException(CardDeclinedException::class);
        $processor->processPayment(100.00, 'tok_123');
    }
}
```

This comprehensive PHPUnit guide covers everything from basic unit testing to advanced integration patterns, providing a solid foundation for PHP testing workflows with modern best practices and real-world examples.
