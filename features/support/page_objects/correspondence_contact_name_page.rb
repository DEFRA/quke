# Correspondence contact name page
class CorrespondenceContactNamePage < SitePrism::Page
  element :fill_contact_name, "input[name='correspondence_contact_name[full_name]']"
  element :fill_contact_position, "input[name='correspondence_contact_name[position]']"
  element :submit_button, "input[name='commit']"
end