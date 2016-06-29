# The config.ru file allows us to use any Rack handler, which in our case is
# [Thin](https://github.com/macournoyer/thin) to start the app, rather than
# relying on Sinatra magic.
# This now means we can start the app using thin directly with direct access
# to all the args you can normally pass into it. We mainly needed this to allow
# us to start the app using thin on Travis-CI, so we could then run the tests
# against it.
require './app'
run Sinatra::Application
