Feature: Test NewsAPI Mock

  Background:
    * url 'http://localhost:8080'

  Scenario: Sports
    Given path '/api/news/headlines'
    And param category = 'sports'
    When method get
    Then status 200
    And match response.articles[0].source.name == 'ESPN'
    And match response.articles[0].title contains 'Manchester United'

  Scenario: Technology
    Given path '/api/news/headlines'
    And param category = 'technology'
    When method get
    Then status 200
    And match response.articles[0].title contains 'AI Gemini'

  Scenario: Bitcoin
    Given path '/api/news/search'
    And param q = 'bitcoin'
    When method get
    Then status 200
    And match response.totalResults == 150
    And match response.articles[0].author == 'Satoshi Nakamoto'

  Scenario: newsources
    Given path '/api/news/sources'
    When method get
    Then status 200

    And match response.sources[2].id == 'vn-express'