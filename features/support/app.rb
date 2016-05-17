# Represents all pages in the application. Was created to avoid needing to
# create individual instances of each page throughout the steps.
# https://github.com/natritmeyer/site_prism#epilogue
class App
  def check_location_page
    CheckLocationPage.new
  end

  def add_exemption_page
    AddExemptionPage.new
  end

  def check_exemptions_page
  	CheckExemptionsPage.new
  end

  def grid_reference_page
 	GridReferencePage.new
  end

  def user_type_page
  	UserTypePage.new
  end

  def organisation_name_page
  	OrganisationNamePage.new
  end

  def correspondence_contact_name_page
    CorrespondenceContactNamePage.new
  end

  def correspondence_contact_telephone_page
    CorrespondenceContactTelephonePage.new
  end
  
end
