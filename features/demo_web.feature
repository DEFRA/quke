Feature: Google Search
  In order to demonstrate testing a web site
  As a capybara, cucumber, and selenium/poltergeist user
  I want to see the if it works on Google search page

Scenario: Searching in google for testing
  Given I am on the home page
  When I fill in "q" with "testing"
  Then I should see "Software testing"

  Scenario: Searching in google for QITG
    Given I am on the home page
    When I fill in "q" with "QITG"
    Then I should see "Is QITG a Scrabble word"
