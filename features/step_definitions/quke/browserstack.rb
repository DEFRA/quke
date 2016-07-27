# The following steps use capybara directly to drive the browser
# --------------------------------------------------------------

Given(/^I am on the google home page$/) do
  visit 'https://www.google.co.uk'
end

When(/^I search for BrowserStack$/) do
  fill_in('q', with: 'BrowserStack')
  find_field('q').native.send_key(:enter)
end

Then(/^I should see the title "([^"]*)"$/) do |title|
  expect(page).to have_title title
end
