# The following steps use the page objects to drive the browser
# -------------------------------------------------------------

Given(/^I am on the css selectors page$/) do
  @app = QukeApp.new
  @app.css_selectors_page.load
  expect(@app.css_selectors_page.title.text).to eq('CSS selector')
end

Then(/^I should be able to select all href links$/) do
  expect(@app.css_selectors_page.links).not_to be_empty
end

Then(/^I should be able to select all the radio buttons$/) do
  expect(@app.css_selectors_page.radio_buttons).not_to be_empty
end

Then(/^I should be able to select all the radio buttons and checkboxes$/) do
  pending
  expect(@app.css_selectors_page.boxes_and_radio_buttons).not_to be_empty
end

Then(/^I should be able to select the about link element$/) do
  expect(@app.css_selectors_page.about_link.text).to eq('About')
end

Then(/^I should be able to select the contact link element$/) do
  expect(@app.css_selectors_page.contact_link.text).to eq('Contact')
end

Then(/^I should be able to select the continue button element$/) do
  expect(@app.css_selectors_page.confirm_button.value).to eq('Continue')
end

# The following steps use capybara directly to drive the browser
# --------------------------------------------------------------

Given(/^I'm at the css selectors page$/) do
  visit 'http://localhost:4567/cssselector'
  expect(page).to have_content('CSS selector')
end

Then(/^I can select all href links$/) do
  expect(page.all('a[href]')).not_to be_empty
end

Then(/^I can select all the radio buttons$/) do
  expect(page.all("input[type='radio']")).not_to be_empty
end

Then(/^I can select all the radio buttons and checkboxes$/) do
  pending
  expect(page.all("input[type~='radio checkbox']")).not_to be_empty
end

Then(/^I can select the about link$/) do
  expect(find("a[href*='about']").text).to eq('About')
end

Then(/^I can select the contact link$/) do
  expect(find("a[href^='/con']").text).to eq('Contact')
end

Then(/^I can select the continue button element$/) do
  expect(find("input[id$='mmit']").value).to eq('Continue')
end
