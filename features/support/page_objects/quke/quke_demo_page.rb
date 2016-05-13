# Main page
class QukeDemoPage < SitePrism::Page
  set_url 'https://en.wikipedia.org/wiki/Main_Page'

  element :search_field, "input[id='searchInput']"
  element :search_button, "input[id='searchButton']"
end
