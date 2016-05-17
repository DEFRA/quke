# Represents all pages in the application. Was created to avoid needing to
# create individual instances of each page throughout the steps.
# https://github.com/natritmeyer/site_prism#epilogue
class App
  def check_location_page
    CheckLocationPage.new
  end

  def add_exemption_page
    AddExemptionPage.new
  end
end
