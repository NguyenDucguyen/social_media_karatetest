Feature: Simulate posts UI with random user

  Scenario: Simulate logged-in user and check posts UI
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When driver 'http://localhost:3000/home'
    # Check for post card or no-posts message
    Then waitFor("//h1|.chakra-card", 5000)
    * def postCount = script("return document.querySelectorAll('.chakra-card').length")
    # If there are posts, assert at least one card exists
    * if (postCount > 0) karate.log('Posts found:', postCount)
    # If no posts, assert the no-posts message
    * if (postCount == 0) match text('//h1') contains 'No posts to show'

  Scenario: Simulate adding a post via UI
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When driver 'http://localhost:3000/home'
    Then waitFor("//button[contains(., 'Share Post')]", 5000)
    When click("//button[contains(., 'Share Post')]")
    Then waitFor("//textarea[@name='description']", 3000)
    * def postDesc = 'UI Test Post ' + rand
    When input("//textarea[@name='description']", postDesc)
    When click("//button[normalize-space(.)='Share']")
    # Wait for modal to close and post to appear
    Then waitFor(".chakra-card", 5000)
    * def found = script("return Array.from(document.querySelectorAll('.chakra-card')).some(card => card.innerText.includes('" + postDesc + "'))")
    And match found == true

  Scenario: Simulate adding a post with a picture via UI
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When driver 'http://localhost:3000/home'
    Then waitFor("//button[contains(., 'Share Post')]", 5000)
    When click("//button[contains(., 'Share Post')]")
    Then waitFor("//textarea[@name='description']", 3000)
    * def postDesc = 'UI Test Post with Image ' + rand
    When input("//textarea[@name='description']", postDesc)
    # Simulate image upload (Karate UI can set file input if not hidden)
    * def imgPath = karate.properties['user.dir'] + '/src/test/java/ui/test-image.png'
    When input("//input[@type='file']", imgPath)
    When click("//button[normalize-space(.)='Share']")
    # Wait for modal to close and post to appear
    Then waitFor(".chakra-card", 5000)
    * def found = script("return Array.from(document.querySelectorAll('.chakra-card')).some(card => card.innerText.includes('" + postDesc + "'))")
    And match found == true
