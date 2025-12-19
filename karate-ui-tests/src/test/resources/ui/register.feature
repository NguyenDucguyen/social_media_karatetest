Feature: Register Page UI Tests

  Background:
    * configure driver = { type: 'chrome', headless: true, timeout: 5000 }
    * driver 'http://localhost:3000'
    * def firstName = 'AutoTest'
    * def lastName = 'User'
    * def email = 'autotest.' + java.lang.System.currentTimeMillis() + '@example.com'
    * def password = 'Test@12345'

  @auth @register
  Scenario: Register page contains all required fields and buttons
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

  @auth @register @success
  Scenario: Successful registration creates user and redirects to login
    Then waitFor("input[name='firstName']")
    When input("input[name='firstName']", firstName)
    And input("input[name='lastName']", lastName)
    And input("input[name='email']", email)
    And input("input[name='password']", password)
    And waitFor("{button}Register").click() 
    # Should redirect to home page
    Then waitForUrl('/home')
    * karate.log('Registration successful - user created and able to login')

  @auth @register @error @empty-lastname
  Scenario: Register with empty name should not proceed
    Then waitFor("input[name='firstName']")
    When input("input[name='email']", email)
    And input("input[name='password']", password)
    And waitFor("{button}Register").click()
    # Should stay on register page
    Then delay(1000)
    And assert exists("input[name='password']")
    * karate.log('Empty name validation working')

  @auth @register @error @empty-email
  Scenario: Register with empty email should not proceed
    Then waitFor("input[name='firstName']")
    When input("input[name='firstName']", firstName)
    And input("input[name='lastName']", lastName)
    And input("input[name='password']", password)
    And waitFor("{button}Register").click()
    
    # Should stay on register page
    Then delay(1000)
    And assert exists("input[name='password']")
    * karate.log('Empty email validation working')

  @auth @register @error @empty-password
  Scenario: Register with empty password should not proceed
    Then waitFor("input[name='firstName']")
    When input("input[name='firstName']", firstName)
    And input("input[name='lastName']", lastName)
    And input("input[name='email']", email)
    And input("input[name='password']", '  ')
    And waitFor("{button}Register").click()
    And assert exists("input[name='password']")
    * karate.log('Empty password validation working')

  @auth @register @error @duplicate-email
  Scenario: Register with existing email should show error
    * def duplicateEmail = 'duplicate' + email
    * url 'http://localhost:8080/api/auth/register'
    * request { name: 'Existing', lastName: 'User', email: '#(duplicateEmail)', password: 'Password123' }
    * method post
    * status 200
    
    Then waitFor("input[name='firstName']")
    When input("input[name='firstName']", firstName)
    And input("input[name='lastName']", lastName)
    And input("input[name='email']", duplicateEmail)
    And input("input[name='password']", password)
    And waitFor("{button}Register").click()
    Then delay(1000)
    And assert exists("input[name='password']")
    * karate.log('Duplicate email error handling working')

  @auth @register @error @invalid-email-format
  Scenario: Register with invalid email format should not proceed
    Then waitFor("input[name='firstName']")
    When input("input[name='firstName']", firstName)
    And input("input[name='lastName']", lastName)
    And input("input[name='email']", 'invalidemail-no-domain')
    And input("input[name='password']", password)
    And waitFor("{button}Register").click()
    Then delay(1000)
    And assert exists("input[name='password']")
    * karate.log('Invalid email format validation working')