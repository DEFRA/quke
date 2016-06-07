# Represents all pages in the application. Was created to avoid needing to
# create individual instances of each page throughout the steps.
# https://github.com/natritmeyer/site_prism#epilogue
class QukeApp
  # Using an attr_reader automatically gives me a my_app.last_page method
  attr_reader :last_page

  def home_page
    @last_page = QukeHomePage.new
  end

  def search_page
    @last_page = QukeSearchPage.new
  end
end
