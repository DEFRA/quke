# User type page
class UserTypePage < SitePrism::Page
  elements :radio_buttons, "input[name='user_type[org_type]']"
  element :submit_button, "input[name='commit']"
end
