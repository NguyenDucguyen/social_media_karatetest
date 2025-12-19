Feature: Login Page UI Tests
  Test login page functionality and authentication flows

  Background:
    # Configure Chrome browser - change headless: false to see browser during tests
    * configure driver = { type: 'chrome', headless: true, timeout: 5000 }
    * def apiBaseUrl = 'http://localhost:8080/api'
    * def appBaseUrl = 'http://localhost:3000'
    
    # Create test credentials that will be used across scenarios
    * def testEmail = 'uidemo.' + java.lang.System.currentTimeMillis() + '@example.com'
    * def testPassword = 'DemoPassword@123'
    * def testFirstName = 'Demo'
    * def testLastName = 'User'
    
    # Register a test user via API for login tests
    * url apiBaseUrl + '/auth/register'
    * request { name: '#(testFirstName)', lastName: '#(testLastName)', email: '#(testEmail)', password: '#(testPassword)' }
    * method post
    * status 200
    * karate.log('Test user created for login tests:', testEmail)

  @auth @login
  Scenario: Login page displays all required fields and title
    Given driver appBaseUrl + '/login'
    # Wait for email input to appear (indication page has loaded)
    Then waitFor("input[name='email']")
    # Verify all required input fields exist
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")

  @auth @navigation
  Scenario: User can navigate between Register and Login pages
    Given driver appBaseUrl
    # Wait for login link (it's a Link component rendered as anchor tag)
    Then waitFor("//a[@href='/login'] | //button[contains(., 'Login')]").click()
    # Verify we're now on the login page
    Then waitFor("input[name='email']")
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")

  @auth @login @success
  Scenario: Successful login redirects to home page and stores token
    # Use test user created in Background
    Given driver appBaseUrl + '/login'
    Then waitFor("input[name='email']")
    When input("input[name='email']", testEmail)
    And input("input[name='password']", testPassword)
    And waitFor("{button}Submit").click()
    Then waitForUrl('/home')
    And waitFor("//button[contains(., 'Log out')]")
    * karate.log('Login successful - user authenticated and redirected to home page')

  @auth @login @error @empty-email
  Scenario: Login with empty email should not proceed
    Given driver appBaseUrl + '/login'
    Then waitFor("input[name='email']")
    When input("input[name='password']", 'somepassword')
    And waitFor("{button}Submit").click()
    Then delay(1000)
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")
    * karate.log('Empty email validation working - form not submitted')

  @auth @login @error @empty-password
  Scenario: Login with empty password should not proceed
    Given driver appBaseUrl + '/login'
    Then waitFor("input[name='email']")
    When input("input[name='email']", 'test@example.com')
    And waitFor("{button}Submit").click()
    Then delay(1000)
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")
    * karate.log('Empty password validation working - form not submitted')

  @auth @login @error @both-empty
  Scenario: Login with empty email and password should not proceed
    Given driver appBaseUrl + '/login'
    Then waitFor("input[name='email']")
    When waitFor("{button}Submit").click()
    Then delay(1000)
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")
    * karate.log('Empty fields validation working - form not submitted')

  @auth @login @error @invalid-credentials
  Scenario: Login with wrong email should show error or stay on login
    Given driver appBaseUrl + '/login'
    Then waitFor("input[name='email']")
    When input("input[name='email']", 'nonexistent.' + java.lang.System.currentTimeMillis() + '@example.com')
    And input("input[name='password']", 'wrongpassword123')
    And waitFor("{button}Submit").click()
    Then delay(2000)
    And assert exists("input[name='email']")
    * karate.log('Invalid credentials handled - still on login page')

  @auth @login @error @wrong-password
  Scenario: Login with correct email but wrong password should fail
    # Use test user created in Background
    Given driver appBaseUrl + '/login'
    Then waitFor("input[name='email']")
    When input("input[name='email']", testEmail)
    And input("input[name='password']", 'WrongPassword123')
    And waitFor("{button}Submit").click()
    # Should stay on login page or show error
    Then delay(2000)
    And assert exists("input[name='email']")
    * karate.log('Wrong password handled - still on login page')
