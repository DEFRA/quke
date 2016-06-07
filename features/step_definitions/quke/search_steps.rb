# The following steps use the page objects to drive the browser
Given(/^I am on the search page$/) do
  @app = QukeApp.new
  @app.search_page.load
  expect(@app.search_page.title.text).to eq('Search')
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |element, text|
  @app.last_page.send(element).set(text)
  @app.last_page.confirm_button.click
end

Then(/^I should see (\d+) results$/) do |num_of_results|
  expect(@app.search_page.results.size).to eq(Integer(num_of_results))
end

Then(/^the content "(.*?)"$/) do |text|
  expect(@app.last_page).to have_content(text)
end

# The following steps use capybara directly to drive the browser
Given(/^I'm at the search page$/) do
  visit 'http://localhost:4567/search'
  expect(page).to have_content('Search')
end

When(/^I enter "([^"]*)" into "([^"]*)"$/) do |value, field|
  fill_in field, with: value
  click_button('commit')
end

Then(/^I should get (\d+) results$/) do |num_of_results|
  expect(page.all('.result').size).to eq(Integer(num_of_results))
end

Then(/^see the following text "([^"]*)"$/) do |text|
  expect(page).to have_content(text)
end
