# Grid reference page
class GridReferencePage < SitePrism::Page
  element :fill_grid_ref, "input[id='grid_reference_grid_reference']"
  element :submit_button, "input[name='commit']"
end