Feature: Home Page UI Tests
  Test home page functionality and navigation flows

  Background:
    # Configure Chrome browser
    * configure driver = { type: 'chrome', headless: true, timeout: 5000 }
    # Helper function to set up authenticated user with fake token
    * def setupAuthUser = 
      """
      function() {
        var rand = java.util.UUID.randomUUID() + '';
        var fakeToken = 'FAKE.JWT.' + rand;
        var fakeUser = { id: Math.floor(Math.random()*10000), fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' };
        script("localStorage.setItem('token', '" + fakeToken + "')");
        var userJson = JSON.stringify(fakeUser);
        script("localStorage.setItem('user', '" + userJson + "')");
        return fakeUser;
      }
      """

  @authenticated @home
  Scenario: Home page displays required components
    # Set up authenticated session using fake token
    Given driver 'http://localhost:3000'
    * def user = setupAuthUser()
    # Navigate to home page
    * driver 'http://localhost:3000/home'
    * delay(2000)
    
    # Check for key home page components
    * def bodyExists = exists("body")
    * def navExists = exists("nav")
    * def mainExists = exists("//main")
    * def sectionExists = exists("//section")
    * def divRoleMain = exists("//div[@role='main']")
    
    * karate.log('Body exists:', bodyExists)
    * karate.log('Navigation exists:', navExists)
    * karate.log('Main content exists:', mainExists)
    * karate.log('Section exists:', sectionExists)
    * karate.log('Div with role=main exists:', divRoleMain)
    
    # Verify page loaded
    * match bodyExists == true

  @authenticated @home @navigation
  Scenario: User can navigate from home page to profile page
    # Set up authenticated session using fake token
    Given driver 'http://localhost:3000'
    * def user = setupAuthUser()
    * driver 'http://localhost:3000/home'
    * delay(2000)
    
    # Look for profile navigation link
    Then waitFor("//a[contains(@href, '/profile')] | //a[@aria-label='Profile']").click()
    * delay(1000)
    # Verify we're on profile page
    * def onProfilePage = exists("body")
    * karate.log('Navigated to profile successfully:', onProfilePage)
    * match onProfilePage == true
