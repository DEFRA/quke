# Check location page
class CheckLocationPage < SitePrism::Page

  set_url "https://floodrisk-fo-qa.herokuapp.com/fre/enrollments/new"
  
  element :choose_radio_button_yes, "input[id='check_location_location_check_yes']"
  element :choose_radio_button_no, "input[id='check_location_location_check_no']"
  element :submit_button, "input[name='commit']"

end