# Radio button page
class QukeRadioButtonPage < SitePrism::Page
  set_url 'http://localhost:4567/radiobutton'

  element :title, 'h1'
  element :confirm_button, "input[name='commit']"
  element :result, "span[id='result']"

  elements :options, "input[name='enrollment[organisation_attributes][type]']"
end
