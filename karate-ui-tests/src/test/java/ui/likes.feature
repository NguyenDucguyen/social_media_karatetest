Feature: Simulate likes UI with random user

  Scenario: Simulate logged-in user and check like button UI
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When driver 'http://localhost:3000/home'
    # Wait for post card or no-posts message
    Then waitFor("//h1|.chakra-card", 5000)
    * def postCount = script("return document.querySelectorAll('.chakra-card').length")
    # If there are posts, check for like button
    * if (postCount > 0) assert exists("//button[contains(., 'Like')]")
    # If no posts, assert the no-posts message
    * if (postCount == 0) match text('//h1') contains 'No posts to show'

  Scenario: Simulate liking a post via UI
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When driver 'http://localhost:3000/home'
    Then waitFor(".chakra-card", 5000)
    * def likeBtn = "(//button[contains(., 'Like')])[1]"
    * def before = script("return document.evaluate('" + likeBtn + "', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue?.innerText.match(/Like (\\d+)/)?.[1] || '0'")
    When click(likeBtn)
    # Wait for like count to update
    * retry until script("return document.evaluate('" + likeBtn + "', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue?.innerText.match(/Like (\\d+)/)?.[1] != '" + before + "'")
    * def after = script("return document.evaluate('" + likeBtn + "', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue?.innerText.match(/Like (\\d+)/)?.[1]")
    And match after == (parseInt(before) + 1) + ''

  Scenario: Simulate adding a comment via UI
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When driver 'http://localhost:3000/home'
    Then waitFor(".chakra-card", 5000)
    When click("(//button[contains(., 'Comment')])[1]")
    Then waitFor("//input[@placeholder='Share a Comment']", 3000)
    * def commentText = 'UI Test Comment ' + rand
    When input("//input[@placeholder='Share a Comment']", commentText)
    When click("//button[normalize-space(.)='Share']")
    # Wait for comment to appear in modal
    Then waitFor("//div[contains(@class,'chakra-card') and contains(., '" + commentText + "')]", 5000)
    And assert exists("//div[contains(@class,'chakra-card') and contains(., '" + commentText + "')]")
