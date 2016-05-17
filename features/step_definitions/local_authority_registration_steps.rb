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
  # sleep(1)
  

  @app.check_exemptions_page.wait_for_submit_button

  expect(page).to have_content 'Electrical cable service crossing a main river'
  expect(page).to have_content 'Footbridge over a main river not more than 8 metres wide from bank to bank'
  
  @app.check_exemptions_page.submit_button.click


# Grid reference page
  @app.grid_reference_page.wait_for_submit_button
  @app.grid_reference_page.fill_grid_ref.set "ST 58132 72695"
  # fill_in('grid_reference_grid_reference', :with => 'ST 58132 72695')
  @app.grid_reference_page.submit_button.click
  # click_button 'Continue'
  
  
# User type page
@app.user_type_page.wait_for_submit_button
@app.user_type_page.radio_buttons.find { |btn| btn.value == 'local_authority' }.click
# choose ('user_type_org_type_local_authority')
# click_button 'Continue'
@app.user_type_page.submit_button.click

#Organisation name page
@app.organisation_name_page.wait_for_submit_button
# fill_in('local_authority_name', :with => 'Testminster council')
@app.organisation_name_page.fill_local_authority_name.set "Testminster council"
# click_button 'Continue'
@app.organisation_name_page.submit_button.click

#Address page
click_button 'Continue'

# Correspondence contact name page
# @app.correspondence_contact_page.fill_contact_name :text => "Joe Bloggs"
fill_in('correspondence_contact_name_full_name', :with => 'Joe Bloggs')
fill_in('correspondence_contact_name_position', :with => 'Project Mangler')
click_button 'Continue'

# Correspondence contact telephone page
fill_in('correspondence_contact_telephone_telephone_number', :with => '01234567899')
click_button 'Continue'


save_and_open_page
end

When(/^I confirm my registration$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I will be informed that my application has been received$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
