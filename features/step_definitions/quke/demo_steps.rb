Given(/^a cucumber that is (\d+) cm long$/) do |length|
  @cucumber = { color: 'green', length: length.to_i }
end

When(/^I (?:cut|chop) (?:it|the cucumber) in (?:halves|half|two)$/) do
  @chopped_cucumbers = [
    { color: @cucumber[:color], length: @cucumber[:length] / 2 },
    { color: @cucumber[:color], length: @cucumber[:length] / 2 }
  ]
end

Then(/^I have two cucumbers$/) do
  expect(@chopped_cucumbers.length).to eq(2)
end

Then(/^both are (\d+) cm long$/) do |length|
  @chopped_cucumbers.each do |cuke|
    expect(cuke[:length]).to eq(length.to_i)
  end
end

Given(/^I am on the home page$/) do
  visit 'https://en.wikipedia.org/wiki/Main_Page'
  expect(page).to have_content('Welcome to Wikipedia')
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |element, text|
  fill_in element, with: text
  click_button('searchButton')
end

Then(/^I should see "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end

Given(/^I am on the wikipedia home page$/) do
  @quke_demo_page = QukeDemoPage.new
  @quke_demo_page.load
  expect(page).to have_content('Welcome to Wikipedia')
end

When(/^I search for "([^"]*)"$/) do |text|
  @quke_demo_page.search_field.set text
  @quke_demo_page.search_button.click
end
