Given(/^I am on the home page$/) do
  puts visit 'http://www.google.com'
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |element, text|
  fill_in element, with: "#{text}\n"
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end
