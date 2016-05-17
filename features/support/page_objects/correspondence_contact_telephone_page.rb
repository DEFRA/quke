# Correspondence contact telephone page
class CorrespondenceContactTelephonePage < SitePrism::Page

  element :fill_telephone_number, "input[id='correspondence_contact_telephone[telephone_number]']"
  element :submit_button, "input[name='commit']"
end