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

Given(/^I am on the wikipedia home page$/) do
  @demo_home = DemoHomePage.new
  @demo_home.load
end

When(/^I search for "([^"]*)"$/) do |text|
  @demo_home.search_field.set text
  @demo_home.search_button.click
end
