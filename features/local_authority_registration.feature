Feature: Local authority registers flood risk activity exemption
  As a local authority
  I want to register a location for a flood risk activity exemptions
  So that I can check that my activity does not harm the environment in that area

Scenario: Local authoriy registers location for flood risk activity exemption
  Given I register an exemption for a local authority
  When I confirm my registration
  Then I will be informed that my application has been received
