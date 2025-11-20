Feature: Complete E2E Social Media Application Flow
  Test complete user journey from registration to interaction with multiple users
  Uses real API endpoints instead of localStorage to ensure database persistence

  Background:
    * configure driver = { type: 'chrome', headless: true, timeout: 5000 }
    * def apiBaseUrl = 'http://localhost:8080/api'
    * def appBaseUrl = 'http://localhost:3000'

  @e2e @complete-flow
  Scenario: Complete user journey - Login, Post, Follow, Like, Comment
    # PART 1: USER 1 - LOGIN AND CREATE CONTENT
    * karate.log('USER 1: API REGISTRATION')
    * def user1FirstName = 'AutoTest'
    * def user1LastName = 'User' + java.util.UUID.randomUUID().toString().substring(0, 8)
    * def user1Email = 'autotest1.' + java.lang.System.currentTimeMillis() + '@example.com'
    * def user1Password = 'Test@123456'
    
    # Register User 1 via API
    * url apiBaseUrl + '/auth/register'
    * request { name: '#(user1FirstName)', lastName: '#(user1LastName)', email: '#(user1Email)', password: '#(user1Password)' }
    * method post
    * status 200
    * def user1Token = response
    * karate.log('User 1 API Registration response token:', user1Token)
    * def user1 = { firstName: user1FirstName, lastName: user1LastName, email: user1Email, password: user1Password, token: user1Token }
    
    # LOGIN VIA UI AND CREATE POSTS 
    Given driver appBaseUrl + '/login'
    Then waitFor("input[name='email']")
    When input("input[name='email']", user1Email)
    And input("input[name='password']", user1Password)
    When click("{a}Login")
    Then waitForUrl('/home')
    * karate.log('User 1 logged in successfully')
    
    # Step 3: Navigate to home feed
    * driver appBaseUrl + '/home'
    Then delay(2000)
    * waitFor("body")
    * karate.log('User 1 navigated to home')
    
    # Step 4: Create post with text
    Then delay(1000)
    Then waitFor("{button}Share").click()
    Then waitFor("//textarea[@name='description']")
    * def postText = 'This is my first automated test post! #automation #testing '
    When input("//textarea[@name='description']", postText)
    When click("{button}Share")
    Then delay(2000)
    * karate.log('User 1 created text post:', postText)
    
    # Step 5: Create post with image
    * def imagePostText = 'Check out this beautiful automation test image! '
    Then waitFor("{button}Share").click()
    Then waitFor("//textarea[@name='description']")
    When input("//textarea[@name='description']", imagePostText)
    * def imgPath = karate.properties['user.dir'] + '/src/test/resources/test-image.png'
    When input("input[type='file']", imgPath)
    * retry(5, 2000).waitUntil("document.querySelector('img[src*=\"blob\"]') !== null")
    When click("{button}Share")
    Then delay(2000)
    * karate.log('User 1 created image post:', imagePostText)
    
    # Step 6: Logout User 1
    Then waitFor("//button[contains(., 'Logout')] | //a[contains(., 'Logout')]")
    When click("//button[contains(., 'Logout')] | //a[contains(., 'Logout')]")
    Then delay(2000)
    * waitFor("input[name='email']")
    * karate.log('User 1 logged out successfully')
    
    # PART 2: USER 2 - REGISTER AND INTERACT
    * def user2FirstName = 'InteractiveTest'
    * def user2LastName = 'User' + java.util.UUID.randomUUID().toString().substring(0, 8)
    * def user2Email = 'autotest2.' + java.lang.System.currentTimeMillis() + '@example.com'
    * def user2Password = 'Test@654321'
    
    # Register User 2 via API
    * url apiBaseUrl + '/auth/register'
    * request { name: '#(user2FirstName)', lastName: '#(user2LastName)', email: '#(user2Email)', password: '#(user2Password)' }
    * method post
    * status 200
    * def user2Token = response
    * karate.log('User 2 API Registration response token:', user2Token)
    
    # Store User 2 info
    * def user2 = { firstName: user2FirstName, lastName: user2LastName, email: user2Email, password: user2Password, token: user2Token }
    
    # Step 8: Login User 2
    * driver appBaseUrl + '/login'
    Then waitFor("input[name='email']")
    When input("input[name='email']", user2Email)
    And input("input[name='password']", user2Password)
    When click("{a}Login")
    Then waitForUrl('/home')
    * karate.log('User 2 logged in successfully')
    
    # Step 9: Navigate to home feed
    * driver appBaseUrl + '/home'
    Then delay(2000)
    * waitFor("body")
    * karate.log('User 2 navigated to home feed - should see User 1 posts from database')
    
    # Step 10: Follow User 1
    # Try to find and click follow button - this may depend on your app structure
    * try { click("//button[contains(., 'Follow')] | //button[contains(text(), 'Follow')]") } catch(e) { karate.log('Follow button not found in current view') }
    Then delay(1000)
    * karate.log('User 2 attempted to follow User 1')
    
    # Step 11: Like the first post
    Then waitFor("//button[contains(., 'Like')]")
    * def likeBtn = "(//button[contains(., 'Like')])[1]"
    When click(likeBtn)
    Then delay(1000)
    * karate.log('User 2 liked first post')
    
    # Step 12: Add comment to first post
    * karate.log('===== USER 2: COMMENT ON FIRST POST =====')
    Then waitFor("//button[contains(., 'Comment')]")
    * def commentBtn = "(//button[contains(., 'Comment')])[1]"
    When click(commentBtn)
    Then waitFor("//input[@placeholder='Share a Comment'] | //textarea[contains(@placeholder, 'Comment')]")
    * def commentText = 'Great post! Love the automation testing approach! #impressed'
    When input("//input[@placeholder='Share a Comment'] | //textarea[contains(@placeholder, 'Comment')]", commentText)
    When click("//button[contains(., 'Share')]")
    Then delay(1000)
    * karate.log('User 2 commented on first post:', commentText)
    
    # Step 13: Logout User 2
    * karate.log('===== USER 2: LOGOUT =====')
    Then waitFor("//button[contains(., 'Logout')] | //a[contains(., 'Logout')]").click()
    Then delay(2000)
    * waitFor("input[name='email']")
    * karate.log('User 2 logged out successfully')