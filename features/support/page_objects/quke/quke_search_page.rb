# Search page
class QukeSearchPage < SitePrism::Page
  set_url 'http://localhost:4567/search'

  element :title, 'h1'
  element :search_input, "input[id='search_input']"
  element :confirm_button, "input[id='commit']"

  elements :results, "div[class='result']"
end
