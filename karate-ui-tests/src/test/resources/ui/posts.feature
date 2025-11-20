Feature: Posts UI Tests
  Test creating, viewing, and managing posts

  Background:
    # Configure Chrome browser
    * configure driver = { type: 'chrome', headless: true, timeout: 5000 }
    # Helper function to set up authenticated user
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
    # Helper function to check if posts exist
    * def getPostCount = 
      """
      function() {
        return parseInt(script("document.querySelectorAll('.chakra-card').length"));
      }
      """

  @posts @view
  Scenario: Authenticated user can see posts feed
    Given driver 'http://localhost:3000'
    * def user = setupAuthUser()
    When driver 'http://localhost:3000/home'
    # Wait for feed content to load
    Then waitFor("h1, .chakra-card")
    # Check post count
    * def postCount = getPostCount()
    # Verify either posts exist or no-posts message
    * if (postCount > 0) karate.log('Feed contains', postCount, 'post(s)')
    * if (postCount == 0) karate.assertTrue(exists("//h1[contains(., 'No posts to show')]"), 'No posts message should exist')

  @posts @create @text
  Scenario: Create post with text only
    Given driver 'http://localhost:3000'
    * def user = setupAuthUser()
    When driver 'http://localhost:3000/home'
    Then waitFor("//button[contains(., 'Share Post')]")
    When click("//button[contains(., 'Share Post')]")
    Then waitFor("//textarea[@name='description']")
    * def postDesc = 'UI Test Post ' + java.util.UUID.randomUUID()
    When input("//textarea[@name='description']", postDesc)
    When click("//button[contains(., 'Share')]")

  @posts @create @image
  Scenario: Create post with image
    Given driver 'http://localhost:3000'
    * def user = setupAuthUser()
    When driver 'http://localhost:3000/home'
    Then waitFor("//button[contains(., 'Share Post')]")
    When click("//button[contains(., 'Share Post')]")
    Then waitFor("//textarea[@name='description']")
    # Create post text
    * def postDesc = 'UI Test Post with Image ' + java.util.UUID.randomUUID()
    When input("//textarea[@name='description']", postDesc)
    * def imgPath = karate.properties['user.dir'] + '/src/test/resources/test-image.png'
    # Upload image
    When input("input[type='file']", imgPath)
    # Wait for image preview to load - check for any img element or allow time for processing
    * retry(10, 1000).waitUntil("document.querySelector('img[src*=\"blob\"]') !== null || document.querySelector('img') !== null")
    When click("//button[contains(., 'Share')]")
    
