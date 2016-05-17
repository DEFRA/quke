# Correspondence contact page
class CorrespondenceContactPage < SitePrism::Page
  element :fill_contact_name, "input[name='correspondence_contact_name_full_name']"
  element :submit_button, "input[name='commit']"
end