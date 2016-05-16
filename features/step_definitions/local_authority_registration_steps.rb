Given(/^I'm a local authority$/) do
    @check_location_page = CheckLocationPage.new
  	@check_location_page.load
  	@check_location_page.choose_radio_button_yes.click
  	@check_location_page.submit_button.click
  	@AddExemptionPage.check_add_exemption_checkbox.select
end

When(/^I register my flood risk activity$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I will be informed that my application has been received$/) do
  pending # Write code here that turns the phrase above into concrete actions
end