Feature: Register Page UI Tests

  Background:
    * configure driver = { type: 'chrome', headless: true, timeout: 5000 }

  @auth @register
  Scenario: Register page contains all required fields and buttons
    Given driver 'http://localhost:3000'
    # Wait for form fields to load
    Then waitFor("input[name='firstName']")
    # Verify all required fields are present
    And assert exists("input[name='firstName']")
    And assert exists("input[name='lastName']")
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")
    # Verify action buttons
    And assert exists("//button[contains(., 'Register')]")
    And assert exists("//a[@href='/login'] | //button[contains(., 'Login')]")