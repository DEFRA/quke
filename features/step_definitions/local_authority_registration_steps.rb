Given(/^I register an exemption for a local authority$/) do
  @app = App.new
  @app.check_location_page.load

  # @app.check_location_page.radio_buttons.each {|btn| puts btn.value}
  @app.check_location_page.radio_buttons.find { |btn| btn.value == 'yes' }.click
  @app.check_location_page.submit_button.click

  @app.add_exemption_page.wait_for_check_boxes
  @app.add_exemption_page.check_boxes.find { |chk| chk.value == '1' }.click
  @app.add_exemption_page.check_boxes.find { |chk| chk.value == '4' }.click

  @app.add_exemption_page.submit_button.click
  sleep(1)
  

  # @app.check_exemptions_page.wait_for_submit_button

  expect(page).to have_content 'Electrical cable service crossing a main river'
  expect(page).to have_content 'Footbridge over a main river not more than 8 metres wide from bank to bank'
  sleep(1)
  # @app.check_exemptions_page.submit_button.click

  click_button 'Continue'

# Grid reference page
  fill_in('grid_reference_grid_reference', :with => 'ST 58132 72695')

  click_button 'Continue'
  
  

# User type page
# @app.user_type_page.radio_buttons.find { |btn| btn.value == 'local_authority' }.click
choose ('user_type_org_type_local_authority')
click_button 'Continue'

#Organisation name
fill_in('local_authority_name', :with => 'Testminster council')
click_button 'Continue'
save_and_open_page
end

When(/^I confirm my registration$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I will be informed that my application has been received$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
