# Check location page
class AddExemptionPage < SitePrism::Page

  
  element :check_add_exemption_checkbox, "input[id='add_exemptions_exemption_ids_1']"
  
  element :submit_button, "input[name='commit']"

  

end