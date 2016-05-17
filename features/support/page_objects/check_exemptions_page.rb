# Check exemptions page
class CheckExemptionsPage < SitePrism::Page
  element :add_another_exemption, "input[name='Add another exemption']"
  element :submit_button, "input[name='commit']"
end