Feature: Simulate follow/unfollow UI with random user

Scenario: Simulate follow and unfollow via UI
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    * def targetId = (Math.floor(Math.random()*10000)+10000) + ''
    Given driver 'http://localhost:3000'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When driver 'http://localhost:3000/profile/' + targetId
    Then waitFor("//button[contains(., 'Follow') or contains(., 'Followed')]", 5000)
    # Click Follow if not already following
    * def followBtn = "//button[contains(., 'Follow') and not(contains(., 'Followed'))]"
    * if (exists(followBtn)) click(followBtn)
    # Wait for button to change to Followed
    Then waitFor("//button[contains(., 'Followed')]", 3000)
    And assert exists("//button[contains(., 'Followed')]")
    # Now unfollow
    When click("//button[contains(., 'Followed')]")
    Then waitFor("//button[contains(., 'Follow') and not(contains(., 'Followed'))]", 3000)
    And assert exists("//button[contains(., 'Follow') and not(contains(., 'Followed'))]")
