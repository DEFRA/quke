Feature: Radio buttons
  When writing my own steps and page objects
  As a user of Quke
  I would like a reference to examples of css selectors

  # Examples are attributed to http://trevordavis.net/blog/css-attribute-selectors-explained/

  # [attr]
  # Whenever the attribute is set. Ex: input[type]
  Scenario: Selecting all elements with a specific attribute using page objects
    Given I am on the css selectors page
     Then I should be able to select all href links

  Scenario: Selecting all elements with a specific attribute using capybara
    Given I'm at the css selectors page
     Then I can select all href links

  # [attr="val"]
  # Whenever the attribute equals the specific value. Ex: input[type="radio"]
  Scenario: Selecting all elements with an attribute of type="radio" using page objects
    Given I am on the css selectors page
     Then I should be able to select all the radio buttons

  Scenario: Selecting all elements with an attribute of type="radio" using capybara
    Given I'm at the css selectors page
     Then I can select all the radio buttons

  # [attr~="val"]
  # Whenever the attribute equals one of the space separated list of values. Ex: input[type~="radio checkbox"]
  Scenario: Selecting all elements with an attribute of type "radio" or "checkbox" using page objects
    Given I am on the css selectors page
     Then I should be able to select all the radio buttons and checkboxes

  Scenario: Selecting all elements with an attribute of type "radio" or "checkobox" using capybara
    Given I'm at the css selectors page
     Then I can select all the radio buttons and checkboxes

  # [attr*="val"]
  # Whenever the attribute contains the value. Ex: a[href*=".com"]
  Scenario: Selecting a link element that contains the value 'About' using page objects
    Given I am on the css selectors page
     Then I should be able to select the about link element

  Scenario: Selecting a link element that contains the value 'About' using capybara
    Given I'm at the css selectors page
     Then I can select the about link

  # [attr^="val"]
  # Whenever the attribute starts with the value. Ex: a[href^="http"]
  Scenario: Selecting a link element that starts with '/con' using page objects
    Given I am on the css selectors page
     Then I should be able to select the contact link element

  Scenario: Selecting a link element that starts with '/con' using capybara
    Given I'm at the css selectors page
     Then I can select the contact link

  # [attr$="val"]
  # Whenever the attribute ends with the value. Ex: a[href$=".pdf"]
  Scenario: Selecting a button element that ends with 'mmit' using page objects
    Given I am on the css selectors page
     Then I should be able to select the continue button element

  Scenario: Selecting a button element that ends with 'mmit' using capybara
    Given I'm at the css selectors page
     Then I can select the continue button element
