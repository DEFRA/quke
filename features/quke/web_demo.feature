@qukedemo
Feature: Wikipedia Search
  In order to demonstrate testing a web site
  As a capybara, cucumber, and selenium/poltergeist user
  I want to see the if it works with Wikipedia home page

Scenario: Searching in wikipedia for "capybara"
  Given I am on the home page
  When I fill in "searchInput" with "capybara"
  Then I should see "The capybara (Hydrochoerus hydrochaeris) is a large rodent"

Scenario: Searching in wikipedia for "capybara (software)"
  Given I am on the home page
  When I fill in "searchInput" with "capybara (software)"
  Then I should see "Capybara is a web-based test automation software"

Scenario: Searching in wikipedia for "capybara (software)" using page objects
  Given I am on the wikipedia home page
  When I search for "capybara (software)"
  Then I should see "Capybara is a web-based test automation software"
