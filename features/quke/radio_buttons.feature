Feature: Radio buttons
  To demonstrate how you can use Quke
  As a user of Quke
  I want to see how to interact with radio buttons and check the results

  Scenario: Confirming number of radio buttons (page objects)
    Given I am on the radio button page
     Then I should see 5 options

  Scenario: Confirming number of radio buttons  (capybara)
    Given I'm at the radio button page
     Then I should get 5 options

  Scenario: Confirming I can select a radio button (page objects)
    Given I am on the radio button page
      And I select an option
     Then I should see a confirmation of my selection

  Scenario: Confirming I can select a radio button (capybara)
    Given I'm at the radio button page
      And I select one of the options
     Then I should my selection confirmed
