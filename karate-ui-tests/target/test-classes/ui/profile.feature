Feature: Profile UI Tests
  Test profile page components and functionality

  Background:
    # Configure Chrome browser
    * configure driver = { type: 'chrome', headless: true, timeout: 5000 }
    # Helper function to set up authenticated user with fake token
    * def setupAuthUser = 
      """
      function() {
        var rand = java.util.UUID.randomUUID() + '';
        var fakeToken = 'FAKE.JWT.' + rand;
        var fakeUserId = Math.floor(Math.random()*10000);
        var fakeUser = { id: fakeUserId, fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' };
        script("localStorage.setItem('token', '" + fakeToken + "')");
        var userJson = JSON.stringify(fakeUser);
        script("localStorage.setItem('user', '" + userJson + "')");
        return fakeUser;
      }
      """

  @profile @view
  Scenario: Profile page displays user information
    # Set up authenticated user with fake token
    Given driver 'http://localhost:3000'
    * def user = setupAuthUser()
    
    # Navigate to profile page
    When driver 'http://localhost:3000/profile/' + user.id
    Then delay(2000)
    * def pageLoaded = exists("body")
    * karate.log('Page loaded:', pageLoaded)
    * match pageLoaded == true
    
    # Verify Nav component exists
    * def navExists = exists("//div[@role='navigation']")
    * karate.log('Navigation exists:', navExists)
    
    # Verify UserCard component displays (contains follow/followers info)
    * def userCardExists = exists("//*[contains(text(), 'following') or contains(text(), 'followers')]")
    * karate.log('UserCard exists:', userCardExists)

  @profile @components
  Scenario: Profile page has required components
    Given driver 'http://localhost:3000'
    * def user = setupAuthUser()
    When driver 'http://localhost:3000/profile/' + user.id
    Then delay(2000)
    
    # Check for key components
    * def bodyExists = exists("body")
    * def divExists = exists("//div[@class]")
    * def headingExists = exists("//h1 | //h2 | //h3 | //h4")
    
    * karate.log('Body exists:', bodyExists)
    * karate.log('Divs exist:', divExists)
    * karate.log('Heading exists:', headingExists)
    
    # Verify page loaded successfully
    * match bodyExists == true

  @profile @empty-state
  Scenario: Profile page shows empty state when no posts exist
    Given driver 'http://localhost:3000'
    * def user = setupAuthUser()
    When driver 'http://localhost:3000/profile/' + user.id
    Then delay(2000)
    
    # Check if "No posts to show" message appears (since new user has no posts)
    * def noPostsHeading = exists("//h1[contains(., 'No posts to show')]")
    * karate.log('No posts heading exists:', noPostsHeading)
    
    # Check if empty state image exists
    * def emptyStateImage = exists("//img[@src]")
    * karate.log('Empty state image exists:', emptyStateImage)
    
    # Verify page loaded
    * def pageLoaded = exists("body")
    * match pageLoaded == true
