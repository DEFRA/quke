# CSS selectors page
class QukeCssSelectorsPage < SitePrism::Page
  set_url 'http://localhost:4567/cssselector'

  element :title, 'h1'
  element :about_link, "a[href*='about']"
  element :contact_link, "a[href^='/con']"
  element :confirm_button, "input[id$='mmit']"

  elements :links, 'a[href]'
  elements :radio_buttons, "input[type='radio']"
  elements :boxes_and_radio_buttons, "input[type~='radio checkbox']"
end
