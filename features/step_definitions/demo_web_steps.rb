Given(/^I am on the home page$/) do
  puts visit 'https://en.wikipedia.org/wiki/Main_Page'
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |element, text|
  fill_in element, with: text
  click_button('searchButton')
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end
