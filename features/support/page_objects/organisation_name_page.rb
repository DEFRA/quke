# Organisation name page
class OrganisationNamePage < SitePrism::Page
  element :fill_local_authority_name, "input[id='local_authority_name']"
  element :submit_button, "input[name='commit']"
end