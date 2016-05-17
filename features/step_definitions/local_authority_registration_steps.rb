Given(/^I'm a local authority$/) do
  @app = App.new
  @app.check_location_page.load

  @app.check_location_page.radio_buttons.find { |btn| btn.value == 'yes' }.click
  @app.check_location_page.submit_button.click

  @app.add_exemption_page.check_boxes.find { |chk| chk.value == '1' }.click
  @app.add_exemption_page.check_boxes.find { |chk| chk.value == '4' }.click

  @app.add_exemption_page.submit_button.click
  save_and_open_page
end

When(/^I register my flood risk activity$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I will be informed that my application has been received$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
