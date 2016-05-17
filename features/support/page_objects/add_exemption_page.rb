# Check location page
class AddExemptionPage < SitePrism::Page
  elements :check_boxes, "input[name='add_exemptions[exemption_ids][]']"
  element :submit_button, "input[name='commit']"
end
