@quke_browserstack
Feature: Browserstack integration
  As a user of Quke
  I want to be able to confirm that integration with Browserstack works

Background:
  Given I am on the google home page

Scenario: Can find search results
  When I search for BrowserStack
  Then I should see the title "BrowserStack - Google Search"
