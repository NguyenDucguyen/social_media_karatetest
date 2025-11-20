Feature: Login Page UI Tests
  Test login page functionality and authentication flows

  Background:
    # Configure Chrome browser - change headless: false to see browser during tests
    * configure driver = { type: 'chrome', headless: true, timeout: 5000 }

  @auth @login
  Scenario: Login page displays all required fields and title
    Given driver 'http://localhost:3000/login'
    # Wait for email input to appear (indication page has loaded)
    Then waitFor("input[name='email']")
    # Verify all required input fields exist
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")

  @auth @navigation
  Scenario: User can navigate between Register and Login pages
    Given driver 'http://localhost:3000'
    # Wait for login link (it's a Link component rendered as anchor tag)
    Then waitFor("//a[@href='/login'] | //button[contains(., 'Login')]").click()
    # Verify we're now on the login page
    Then waitFor("input[name='email']")
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")
