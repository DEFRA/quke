# Check location page
class CheckLocationPage < SitePrism::Page
  set_url 'https://floodrisk-fo-qa.herokuapp.com/fre/enrollments/new'

  elements :radio_buttons, "input[name='check_location[location_check]']"
  element  :submit_button, "input[name='commit']"
end
