````instructions
# Selenium WebDriver Testing Framework Instructions

## Tool Overview
- **Tool Name**: Selenium WebDriver
- **Version**: 4.15+ (stable), 4.21+ (latest with enhanced features)
- **Category**: Testing Tools
- **Purpose**: Web browser automation and end-to-end testing framework
- **Prerequisites**: Java 8+ (for Java bindings), Python 3.8+ (for Python), Node.js 16+ (for JavaScript)

## Installation & Setup
### Java Installation
```bash
# Maven dependency
<dependency>
    <groupId>org.seleniumhq.selenium</groupId>
    <artifactId>selenium-java</artifactId>
    <version>4.21.0</version>
</dependency>

# Gradle dependency
implementation 'org.seleniumhq.selenium:selenium-java:4.21.0'
testImplementation 'org.seleniumhq.selenium:selenium-java:4.21.0'

# Download and install browser drivers
# Chrome Driver
curl -O https://chromedriver.storage.googleapis.com/LATEST_RELEASE
# Or use WebDriverManager
<dependency>
    <groupId>io.github.bonigarcia</groupId>
    <artifactId>webdrivermanager</artifactId>
    <version>5.3.3</version>
</dependency>
```

### Python Installation
```bash
# pip installation
pip install selenium

# With additional testing frameworks
pip install selenium pytest pytest-html
pip install selenium webdriver-manager

# Virtual environment setup
python -m venv selenium-env
source selenium-env/bin/activate  # On Windows: selenium-env\Scripts\activate
pip install selenium pytest webdriver-manager
```

### JavaScript/Node.js Installation
```bash
# npm installation
npm install --save-dev selenium-webdriver

# yarn installation
yarn add --dev selenium-webdriver

# With additional testing frameworks
npm install --save-dev selenium-webdriver mocha chai
npm install --save-dev selenium-webdriver jest

# Browser drivers
npm install --save-dev chromedriver geckodriver
```

### Browser Driver Setup
```bash
# Install ChromeDriver
npm install -g chromedriver

# Install GeckoDriver (Firefox)
npm install -g geckodriver

# Install EdgeDriver
npm install -g edgedriver

# Using WebDriverManager (Python)
pip install webdriver-manager

# Using WebDriverManager (Java) - already shown above
```

## Core Features

### Basic WebDriver Setup
- **Purpose**: Initialize browser instances and manage driver lifecycle
- **Usage**: Create driver instances for different browsers
- **Example**:

**Java:**
```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import io.github.bonigarcia.wdm.WebDriverManager;

public class WebDriverSetup {
    private WebDriver driver;

    public void setupChrome() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless"); // Run in headless mode
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        driver = new ChromeDriver(options);
    }

    public void setupFirefox() {
        WebDriverManager.firefoxdriver().setup();
        driver = new FirefoxDriver();
    }

    public void setupEdge() {
        WebDriverManager.edgedriver().setup();
        driver = new EdgeDriver();
    }

    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
```

**Python:**
```python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager

class WebDriverSetup:
    def __init__(self):
        self.driver = None

    def setup_chrome(self, headless=False):
        options = ChromeOptions()
        if headless:
            options.add_argument('--headless')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--disable-gpu')

        self.driver = webdriver.Chrome(
            service=webdriver.ChromeService(ChromeDriverManager().install()),
            options=options
        )
        return self.driver

    def setup_firefox(self, headless=False):
        options = FirefoxOptions()
        if headless:
            options.add_argument('--headless')

        self.driver = webdriver.Firefox(
            service=webdriver.FirefoxService(GeckoDriverManager().install()),
            options=options
        )
        return self.driver

    def teardown(self):
        if self.driver:
            self.driver.quit()
```

**JavaScript:**
```javascript
const { Builder, Browser, By, until } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const firefox = require('selenium-webdriver/firefox');

class WebDriverSetup {
    constructor() {
        this.driver = null;
    }

    async setupChrome(headless = false) {
        const options = new chrome.Options();
        if (headless) {
            options.addArguments('--headless');
        }
        options.addArguments('--no-sandbox');
        options.addArguments('--disable-dev-shm-usage');

        this.driver = await new Builder()
            .forBrowser(Browser.CHROME)
            .setChromeOptions(options)
            .build();

        return this.driver;
    }

    async setupFirefox(headless = false) {
        const options = new firefox.Options();
        if (headless) {
            options.addArguments('--headless');
        }

        this.driver = await new Builder()
            .forBrowser(Browser.FIREFOX)
            .setFirefoxOptions(options)
            .build();

        return this.driver;
    }

    async tearDown() {
        if (this.driver) {
            await this.driver.quit();
        }
    }
}

module.exports = WebDriverSetup;
```

### Element Location and Interaction
- **Purpose**: Find and interact with web elements
- **Usage**: Use various locator strategies to find elements
- **Example**:

**Java:**
```java
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import java.time.Duration;

public class ElementInteraction {
    private WebDriver driver;
    private WebDriverWait wait;

    public ElementInteraction(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    public void basicInteractions() {
        // Navigate to page
        driver.get("https://example.com/form");

        // Find elements by different locators
        WebElement usernameField = driver.findElement(By.id("username"));
        WebElement passwordField = driver.findElement(By.name("password"));
        WebElement submitButton = driver.findElement(By.xpath("//button[@type='submit']"));
        WebElement linkElement = driver.findElement(By.linkText("Click here"));

        // Interact with elements
        usernameField.clear();
        usernameField.sendKeys("testuser");

        passwordField.sendKeys("password123");

        // Select dropdown
        WebElement dropdown = driver.findElement(By.id("country"));
        Select select = new Select(dropdown);
        select.selectByVisibleText("United States");

        // Checkbox and radio buttons
        WebElement checkbox = driver.findElement(By.id("agree-terms"));
        if (!checkbox.isSelected()) {
            checkbox.click();
        }

        // Submit form
        submitButton.click();

        // Wait for result
        WebElement successMessage = wait.until(
            ExpectedConditions.visibilityOfElementLocated(
                By.className("success-message")
            )
        );

        System.out.println("Success: " + successMessage.getText());
    }

    public void advancedInteractions() {
        // Hover over element
        Actions actions = new Actions(driver);
        WebElement hoverElement = driver.findElement(By.id("hover-menu"));
        actions.moveToElement(hoverElement).perform();

        // Drag and drop
        WebElement source = driver.findElement(By.id("draggable"));
        WebElement target = driver.findElement(By.id("droppable"));
        actions.dragAndDrop(source, target).perform();

        // Double click
        WebElement doubleClickElement = driver.findElement(By.id("double-click"));
        actions.doubleClick(doubleClickElement).perform();

        // Right click
        WebElement rightClickElement = driver.findElement(By.id("right-click"));
        actions.contextClick(rightClickElement).perform();
    }
}
```

**Python:**
```python
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait, Select
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys

class ElementInteraction:
    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10)

    def basic_interactions(self):
        # Navigate to page
        self.driver.get("https://example.com/form")

        # Find elements by different locators
        username_field = self.driver.find_element(By.ID, "username")
        password_field = self.driver.find_element(By.NAME, "password")
        submit_button = self.driver.find_element(By.XPATH, "//button[@type='submit']")
        link_element = self.driver.find_element(By.LINK_TEXT, "Click here")

        # Interact with elements
        username_field.clear()
        username_field.send_keys("testuser")

        password_field.send_keys("password123")

        # Select dropdown
        dropdown = Select(self.driver.find_element(By.ID, "country"))
        dropdown.select_by_visible_text("United States")

        # Checkbox and radio buttons
        checkbox = self.driver.find_element(By.ID, "agree-terms")
        if not checkbox.is_selected():
            checkbox.click()

        # Submit form
        submit_button.click()

        # Wait for result
        success_message = self.wait.until(
            EC.visibility_of_element_located((By.CLASS_NAME, "success-message"))
        )

        print(f"Success: {success_message.text}")

    def advanced_interactions(self):
        actions = ActionChains(self.driver)

        # Hover over element
        hover_element = self.driver.find_element(By.ID, "hover-menu")
        actions.move_to_element(hover_element).perform()

        # Drag and drop
        source = self.driver.find_element(By.ID, "draggable")
        target = self.driver.find_element(By.ID, "droppable")
        actions.drag_and_drop(source, target).perform()

        # Double click
        double_click_element = self.driver.find_element(By.ID, "double-click")
        actions.double_click(double_click_element).perform()

        # Right click
        right_click_element = self.driver.find_element(By.ID, "right-click")
        actions.context_click(right_click_element).perform()

        # Keyboard shortcuts
        actions.key_down(Keys.CONTROL).send_keys('a').key_up(Keys.CONTROL).perform()
```

### Waiting Strategies
- **Purpose**: Handle dynamic content and ensure elements are ready
- **Usage**: Implement explicit and implicit waits
- **Example**:

**Java:**
```java
import org.openqa.selenium.support.ui.FluentWait;
import java.util.NoSuchElementException;

public class WaitingStrategies {
    private WebDriver driver;
    private WebDriverWait wait;

    public WaitingStrategies(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    public void explicitWaits() {
        // Wait for element to be visible
        WebElement element = wait.until(
            ExpectedConditions.visibilityOfElementLocated(By.id("dynamic-content"))
        );

        // Wait for element to be clickable
        WebElement button = wait.until(
            ExpectedConditions.elementToBeClickable(By.id("submit-btn"))
        );
        button.click();

        // Wait for text to be present
        wait.until(ExpectedConditions.textToBePresentInElement(
            driver.findElement(By.id("status")), "Complete"
        ));

        // Wait for URL to contain specific text
        wait.until(ExpectedConditions.urlContains("/success"));

        // Wait for element to disappear
        wait.until(ExpectedConditions.invisibilityOfElementLocated(
            By.id("loading-spinner")
        ));
    }

    public void fluentWait() {
        FluentWait<WebDriver> fluentWait = new FluentWait<>(driver)
            .withTimeout(Duration.ofSeconds(30))
            .pollingEvery(Duration.ofSeconds(2))
            .ignoring(NoSuchElementException.class);

        WebElement element = fluentWait.until(driver -> {
            try {
                WebElement el = driver.findElement(By.id("slow-loading-element"));
                return el.isDisplayed() ? el : null;
            } catch (NoSuchElementException e) {
                return null;
            }
        });
    }

    public void implicitWait() {
        // Set implicit wait (applies to all element finding operations)
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
    }
}
```

**Python:**
```python
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException

class WaitingStrategies:
    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10)

    def explicit_waits(self):
        try:
            # Wait for element to be visible
            element = self.wait.until(
                EC.visibility_of_element_located((By.ID, "dynamic-content"))
            )

            # Wait for element to be clickable
            button = self.wait.until(
                EC.element_to_be_clickable((By.ID, "submit-btn"))
            )
            button.click()

            # Wait for text to be present
            self.wait.until(
                EC.text_to_be_present_in_element(
                    (By.ID, "status"), "Complete"
                )
            )

            # Wait for URL to contain specific text
            self.wait.until(EC.url_contains("/success"))

            # Wait for element to disappear
            self.wait.until(
                EC.invisibility_of_element_located((By.ID, "loading-spinner"))
            )

        except TimeoutException:
            print("Element did not appear within the timeout period")

    def custom_wait_condition(self):
        def element_has_css_class(locator, css_class):
            def _predicate(driver):
                element = driver.find_element(*locator)
                return css_class in element.get_attribute('class')
            return _predicate

        # Wait for element to have specific CSS class
        self.wait.until(
            element_has_css_class((By.ID, "status-indicator"), "success")
        )

    def implicit_wait(self):
        # Set implicit wait (applies to all element finding operations)
        self.driver.implicitly_wait(10)
```

## Common Commands & Usage

### Test Execution Patterns
```bash
# Java with TestNG
mvn test -Dtest=SeleniumTest
mvn test -Dtest=SeleniumTest -Dbrowser=chrome
mvn test -Dtest=SeleniumTest -Dheadless=true

# Java with JUnit
mvn test -Dtest=**/*Test.java
gradle test --tests SeleniumTest

# Python with pytest
pytest tests/test_selenium.py
pytest tests/test_selenium.py -v --html=report.html
pytest tests/test_selenium.py -k "test_login"
pytest tests/test_selenium.py --browser=firefox
pytest tests/test_selenium.py --headless

# JavaScript with Mocha
npm test
npm run test:selenium
npm run test:selenium -- --grep "login"

# JavaScript with Jest
npx jest selenium.test.js
npx jest selenium.test.js --verbose
npx jest selenium.test.js --detectOpenHandles
```

## Advanced Features

### Page Object Model Pattern
**Java:**
```java
// BasePage.java
public abstract class BasePage {
    protected WebDriver driver;
    protected WebDriverWait wait;

    public BasePage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        PageFactory.initElements(driver, this);
    }
}

// LoginPage.java
public class LoginPage extends BasePage {
    @FindBy(id = "username")
    private WebElement usernameField;

    @FindBy(id = "password")
    private WebElement passwordField;

    @FindBy(xpath = "//button[@type='submit']")
    private WebElement loginButton;

    @FindBy(className = "error-message")
    private WebElement errorMessage;

    public LoginPage(WebDriver driver) {
        super(driver);
    }

    public void enterUsername(String username) {
        usernameField.clear();
        usernameField.sendKeys(username);
    }

    public void enterPassword(String password) {
        passwordField.clear();
        passwordField.sendKeys(password);
    }

    public HomePage clickLoginButton() {
        loginButton.click();
        return new HomePage(driver);
    }

    public String getErrorMessage() {
        wait.until(ExpectedConditions.visibilityOf(errorMessage));
        return errorMessage.getText();
    }

    public HomePage login(String username, String password) {
        enterUsername(username);
        enterPassword(password);
        return clickLoginButton();
    }
}

// Test class
public class LoginTest {
    private WebDriver driver;
    private LoginPage loginPage;

    @BeforeEach
    void setUp() {
        WebDriverManager.chromedriver().setup();
        driver = new ChromeDriver();
        loginPage = new LoginPage(driver);
    }

    @Test
    void testSuccessfulLogin() {
        driver.get("https://example.com/login");
        HomePage homePage = loginPage.login("testuser", "password123");

        assertTrue(homePage.isLoggedIn());
    }

    @Test
    void testInvalidLogin() {
        driver.get("https://example.com/login");
        loginPage.login("invalid", "credentials");

        assertEquals("Invalid credentials", loginPage.getErrorMessage());
    }

    @AfterEach
    void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
```

**Python:**
```python
# pages/base_page.py
class BasePage:
    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10)

    def find_element(self, locator):
        return self.wait.until(EC.presence_of_element_located(locator))

    def click_element(self, locator):
        element = self.wait.until(EC.element_to_be_clickable(locator))
        element.click()

    def enter_text(self, locator, text):
        element = self.find_element(locator)
        element.clear()
        element.send_keys(text)

# pages/login_page.py
class LoginPage(BasePage):
    USERNAME_FIELD = (By.ID, "username")
    PASSWORD_FIELD = (By.ID, "password")
    LOGIN_BUTTON = (By.XPATH, "//button[@type='submit']")
    ERROR_MESSAGE = (By.CLASS_NAME, "error-message")

    def __init__(self, driver):
        super().__init__(driver)

    def enter_username(self, username):
        self.enter_text(self.USERNAME_FIELD, username)

    def enter_password(self, password):
        self.enter_text(self.PASSWORD_FIELD, password)

    def click_login_button(self):
        self.click_element(self.LOGIN_BUTTON)
        from pages.home_page import HomePage
        return HomePage(self.driver)

    def get_error_message(self):
        error_element = self.wait.until(
            EC.visibility_of_element_located(self.ERROR_MESSAGE)
        )
        return error_element.text

    def login(self, username, password):
        self.enter_username(username)
        self.enter_password(password)
        return self.click_login_button()

# tests/test_login.py
import pytest
from pages.login_page import LoginPage

class TestLogin:
    def test_successful_login(self, driver):
        driver.get("https://example.com/login")
        login_page = LoginPage(driver)
        home_page = login_page.login("testuser", "password123")

        assert home_page.is_logged_in()

    def test_invalid_login(self, driver):
        driver.get("https://example.com/login")
        login_page = LoginPage(driver)
        login_page.login("invalid", "credentials")

        assert "Invalid credentials" in login_page.get_error_message()
```

### Data-Driven Testing
**Java with TestNG:**
```java
public class DataDrivenTest {
    private WebDriver driver;

    @DataProvider(name = "loginData")
    public Object[][] getLoginData() {
        return new Object[][] {
            {"user1", "pass1", true},
            {"user2", "pass2", true},
            {"invalid", "invalid", false},
            {"", "pass", false},
            {"user", "", false}
        };
    }

    @Test(dataProvider = "loginData")
    public void testLogin(String username, String password, boolean shouldSucceed) {
        LoginPage loginPage = new LoginPage(driver);
        driver.get("https://example.com/login");

        if (shouldSucceed) {
            HomePage homePage = loginPage.login(username, password);
            assertTrue(homePage.isLoggedIn());
        } else {
            loginPage.login(username, password);
            assertTrue(loginPage.hasError());
        }
    }
}
```

**Python with pytest and parametrize:**
```python
@pytest.mark.parametrize("username,password,should_succeed", [
    ("user1", "pass1", True),
    ("user2", "pass2", True),
    ("invalid", "invalid", False),
    ("", "pass", False),
    ("user", "", False)
])
def test_login(driver, username, password, should_succeed):
    driver.get("https://example.com/login")
    login_page = LoginPage(driver)

    if should_succeed:
        home_page = login_page.login(username, password)
        assert home_page.is_logged_in()
    else:
        login_page.login(username, password)
        assert login_page.has_error()
```

### Cross-Browser Testing
```python
# conftest.py (pytest configuration)
import pytest
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions

def pytest_addoption(parser):
    parser.addoption("--browser", action="store", default="chrome")
    parser.addoption("--headless", action="store_true")

@pytest.fixture
def browser(request):
    return request.config.getoption("--browser")

@pytest.fixture
def headless(request):
    return request.config.getoption("--headless")

@pytest.fixture
def driver(browser, headless):
    if browser == "chrome":
        options = ChromeOptions()
        if headless:
            options.add_argument("--headless")
        driver = webdriver.Chrome(options=options)
    elif browser == "firefox":
        options = FirefoxOptions()
        if headless:
            options.add_argument("--headless")
        driver = webdriver.Firefox(options=options)
    else:
        raise ValueError(f"Unsupported browser: {browser}")

    driver.maximize_window()
    yield driver
    driver.quit()

# Run tests with different browsers:
# pytest --browser=chrome
# pytest --browser=firefox
# pytest --browser=chrome --headless
```

## CI/CD Integration

### GitHub Actions
```yaml
# .github/workflows/selenium-tests.yml
name: Selenium Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        browser: [chrome, firefox]
        python-version: [3.9, 3.10, 3.11]

    steps:
    - uses: actions/checkout@v4

    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}

    - name: Install dependencies
      run: |
        pip install -r requirements.txt
        pip install pytest selenium webdriver-manager

    - name: Install Chrome
      if: matrix.browser == 'chrome'
      uses: browser-actions/setup-chrome@latest

    - name: Install Firefox
      if: matrix.browser == 'firefox'
      uses: browser-actions/setup-firefox@latest

    - name: Run Selenium tests
      run: |
        pytest tests/ --browser=${{ matrix.browser }} --headless -v

    - name: Upload test results
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: test-results-${{ matrix.browser }}-${{ matrix.python-version }}
        path: test-results/
```

### Docker Integration
```dockerfile
# Dockerfile for Selenium tests
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get install -y google-chrome-stable

# Install Python dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy test files
COPY tests/ /app/tests/
COPY pages/ /app/pages/
WORKDIR /app

# Run tests
CMD ["pytest", "tests/", "--headless", "-v"]
```

## Common Issues & Solutions

### Element Not Found
**Problem**: NoSuchElementException when trying to find elements
**Solution**: Use proper waits and verify locators
```python
# ❌ Bad: Immediate element finding
element = driver.find_element(By.ID, "dynamic-element")

# ✅ Good: Wait for element
wait = WebDriverWait(driver, 10)
element = wait.until(EC.presence_of_element_located((By.ID, "dynamic-element")))
```

### Stale Element Reference
**Problem**: StaleElementReferenceException when element DOM changes
**Solution**: Re-find elements after page changes
```python
# ❌ Bad: Reusing old element reference
button = driver.find_element(By.ID, "submit")
# ... page refresh or navigation
button.click()  # Will throw StaleElementReferenceException

# ✅ Good: Find element again
def click_submit_button():
    button = driver.find_element(By.ID, "submit")
    button.click()
```

### Flaky Tests
**Problem**: Tests fail intermittently due to timing issues
**Solution**: Implement robust waiting strategies
```python
def wait_for_page_load(driver, timeout=10):
    wait = WebDriverWait(driver, timeout)
    wait.until(lambda driver: driver.execute_script("return document.readyState") == "complete")

def wait_for_ajax(driver, timeout=10):
    wait = WebDriverWait(driver, timeout)
    wait.until(lambda driver: driver.execute_script("return jQuery.active == 0"))
```

## Useful Resources
- **Official Documentation**: https://selenium-python.readthedocs.io/
- **Java Documentation**: https://seleniumhq.github.io/selenium/docs/api/java/
- **JavaScript Documentation**: https://seleniumhq.github.io/selenium/docs/api/javascript/
- **WebDriver W3C Specification**: https://w3c.github.io/webdriver/
- **Selenium Grid**: https://selenium-python.readthedocs.io/en/stable/api.html

## Tool-Specific Guidelines

### Best Practices
- Use Page Object Model for maintainable test code
- Implement proper waiting strategies instead of sleep()
- Keep tests independent and isolated
- Use meaningful test data and avoid hardcoded values
- Implement proper error handling and cleanup

### Performance Tips
- Run tests in parallel using Selenium Grid or cloud services
- Use headless browsers for faster execution in CI/CD
- Minimize browser interactions and combine actions when possible
- Implement smart waits instead of implicit waits everywhere
- Use browser options to disable unnecessary features

### Security Considerations
- Never hardcode credentials in test code
- Use environment variables or secure vaults for sensitive data
- Validate SSL certificates in production-like environments
- Clean up test data after test execution
- Use isolated test environments

## Version Compatibility
- **Java**: 8+ (11+ recommended)
- **Python**: 3.8+ (3.11+ recommended)
- **Node.js**: 16+ (18+ recommended)
- **Browsers**: Latest stable versions of Chrome, Firefox, Safari, Edge

## Troubleshooting

### Debug Mode
```python
# Enable verbose logging
import logging
logging.basicConfig(level=logging.DEBUG)

# Take screenshots on failure
def capture_screenshot_on_failure(driver, test_name):
    driver.save_screenshot(f"screenshots/{test_name}_failure.png")

# Browser console logs
logs = driver.get_log('browser')
for log in logs:
    print(log)
```

### Common Error Messages
- **Error**: `WebDriverException: Message: unknown error: Chrome failed to start`
  **Cause**: Chrome not properly installed or insufficient permissions
  **Solution**: Install Chrome properly and use appropriate options

- **Error**: `TimeoutException: Message:`
  **Cause**: Element not found within specified timeout
  **Solution**: Increase timeout or check element locator

- **Error**: `SessionNotCreatedException`
  **Cause**: WebDriver version incompatible with browser version
  **Solution**: Update WebDriver or use WebDriverManager for automatic management
````
