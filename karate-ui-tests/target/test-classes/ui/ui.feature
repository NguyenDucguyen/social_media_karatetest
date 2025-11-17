Feature: React App UI smoke tests (UI only)

  Background:
    # use Chrome in headless mode by default; change headless:false to see the browser
    * configure driver = { type: 'chrome', headless: true }

  Scenario: Login page has inputs and correct title
    Given driver 'http://localhost:3000/login'
    # wait for email input to appear (timeout in ms)
    Then waitFor("input[name='email']", 5000)
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")
    And match title contains 'React App'

  Scenario: Register page has expected fields and buttons
    Given driver 'http://localhost:3000/register'
    Then waitFor("input[name='firstName']", 3000)
    And assert exists("input[name='firstName']")
    And assert exists("input[name='lastName']")
    And assert exists("input[name='email']")
    And assert exists("input[name='password']")
    And assert exists("//button[normalize-space(.)='Register']")
    And assert exists("//button[normalize-space(.)='Login']")

  Scenario: Register -> Login navigation works
    Given driver 'http://localhost:3000/register'
    Then waitFor("//button[normalize-space(.)='Login']", 3000)
    When click("//button[normalize-space(.)='Login']")
    Then waitFor("input[name='email']", 3000)
    And assert exists("input[name='email']")

  Scenario: Home shows no-posts message when unauthenticated and navbar exists
    Given driver 'http://localhost:3000/home'
    Then waitFor("h1", 3000)
    And assert exists("//h1[contains(., 'No posts to show')]")
    # verify nav buttons are present (Home, Profile)
    And assert exists("//button[contains(., 'Home')]")
    And assert exists("//button[contains(., 'Profile')]")

  Scenario: Profile navigation from Nav shows profile page (no-posts message)
    Given driver 'http://localhost:3000/home'
    Then waitFor("//button[contains(., 'Profile')]", 3000)
    When click("//button[contains(., 'Profile')]")
    Then waitFor("//h1[contains(., 'No posts to show')]|//h1", 5000)
    And assert exists("//h1[contains(., 'No posts to show')]")

  Scenario: Simulate logged-in user for Login page
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000/login'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When reload()
    Then waitFor("//button[contains(., 'Log out')]", 5000)
    And assert exists("//button[contains(., 'Log out')]")

  Scenario: Simulate logged-in user for Register page
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000/register'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When reload()
    Then waitFor("//button[contains(., 'Log out')]", 5000)
    And assert exists("//button[contains(., 'Log out')]")

  Scenario: Simulate logged-in user for Home page
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When driver 'http://localhost:3000/home'
    Then waitFor("//button[contains(., 'Log out')]", 5000)
    And assert exists("//button[contains(., 'Log out')]")

  Scenario: Simulate logged-in user for Profile page
    * def rand = java.util.UUID.randomUUID() + ''
    * def fakeToken = 'FAKE.JWT.' + rand
    * def fakeUser = { id: '#(Math.floor(Math.random()*10000))', fullName: 'Test User ' + rand, email: 'test' + rand + '@example.com' }
    Given driver 'http://localhost:3000'
    * script("localStorage.setItem('token', '" + fakeToken + "')")
    * script("localStorage.setItem('user', JSON.stringify(" + karate.toJson(fakeUser) + "))")
    When driver 'http://localhost:3000/profile/' + fakeUser.id
    Then waitFor("//button[contains(., 'Log out')]", 5000)
    And assert exists("//button[contains(., 'Log out')]")
