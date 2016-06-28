# The following steps use the page objects to drive the browser
Given(/^I am on the radio button page$/) do
  @app = QukeApp.new
  @app.radio_button_page.load
  expect(@app.radio_button_page.title.text).to eq('Radio button')
end

Then(/^I should see (\d+) options$/) do |num_of_results|
  expect(@app.radio_button_page.options.size).to eq(Integer(num_of_results))
end

Given(/^I select an option$/) do
  # This demonstrates reuse of a step. We want to ensure we can see options
  # before trying to select one, but rather than repeat the same expectation
  # we instead reuse the step that does this.
  step 'I should see 5 options'

  # rubocop: disable LineLength
  @app.radio_button_page.options.find { |btn| btn.value == 'WasteExemptionsShared::OrganisationType::Partnership' }.click
  # rubocop: enable LineLength

  @app.radio_button_page.confirm_button.click
end

Then(/^I should see a confirmation of my selection$/) do
  expect(@app.radio_button_page.result.text).to end_with('Partnership')
end

# The following steps use capybara directly to drive the browser
Given(/^I'm at the radio button page$/) do
  visit 'http://localhost:4567/radiobutton'
  expect(page).to have_content('Radio button')
end

Then(/^I should get (\d+) options$/) do |num_of_results|
  expect(page.all('input[type=radio]').size).to eq(Integer(num_of_results))
end

Given(/^I select one of the options$/) do
  # This demonstrates reuse of a step. We want to ensure we can see options
  # before trying to select one, but rather than repeat the same expectation
  # we instead reuse the step that does this.
  step 'I should get 5 options'
  choose('organisation_partnership')
  click_button('commit')
end

Then(/^I should my selection confirmed$/) do
  expect(find('span[id=result]').text).to end_with('Partnership')
end
