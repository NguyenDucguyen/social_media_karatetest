Feature: Complete E2E Social Media Application Flow
  Test complete user journey from registration to interaction with multiple users
  Uses real API endpoints instead of localStorage to ensure database persistence

  Background:
    * configure driver = { type: 'chrome', headless: false, timeout: 5000 }
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
    When waitFor("{button}Submit").click()
    Then waitForUrl('/home')
    * karate.log('User 1 logged in successfully')
    
    # Step 3: Navigate to home feed
    * driver appBaseUrl + '/home'
    Then delay(2000)
    * waitFor("body")
    * karate.log('User 1 navigated to home')
    
    # Step 4: Create post with text
    Then delay(1000)
    Then waitFor("{button}Share Post").click()
    Then waitFor("//textarea[@name='description']")
    * def postText = 'This is my first automated test post! #automation #testing '
    When input("//textarea[@name='description']", postText)
    When waitFor("{button}Share").click()
    Then delay(2000)
    * karate.log('User 1 created text post:', postText)
    
    # Step 5: Create post with image
    * def imagePostText = 'Check out this beautiful automation test image! '
    Then waitFor("{button}Share Post").click()
    Then waitFor("//textarea[@name='description']")
    When input("//textarea[@name='description']", imagePostText)
    * def imgPath = './src/test/resources/test-image.jpg'
    When driver.inputFile("input[type='file']", imgPath)
    * delay(2000)
    When waitFor(".post-share-btn").click()
    Then delay(2000)
    * karate.log('User 1 created image post:', imagePostText)
    
    # Step 7: Like a post (first post on profile)
    * waitFor(".like-btn").click()
    Then delay(1000)
    * karate.log('User 1 liked the first post')
    
    # Step 8: Unlike the post
    * waitFor(".like-btn").click()
    Then delay(1000)
    * karate.log('User 1 unliked the post')
    
    # Step 9: Add a comment
    * waitFor(".comment-btn").click()
    Then delay(1500)
    * karate.log('User 1 opened comment section')
    * def commentText = 'Great post! This is an automated test comment #awesome'
    * waitFor("input[name='description']").input(commentText)
    Then delay(500)
    * karate.log('User 1 typed comment:', commentText)
    
    # Step 10: Share/Submit the comment
    * waitFor(".comment-share-btn").click()
    Then delay(1500)
    * karate.log('User 1 shared the comment')
    * waitFor("[aria-label='Close']").click()
    
    # Step 11: Logout User 1
    * driver appBaseUrl + '/home'
    * retry(5, 2000).waitFor("//button[contains(text(), 'Log out')]").click()
    Then delay(2000)
    * waitFor("input[name='email']")
    * karate.log('User 1 logged out successfully')
    
    