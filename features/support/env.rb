require 'rspec/expectations'
require 'capybara/cucumber'
require 'site_prism'
require 'require_all'

# load all ruby files in the directory "lib" and its subdirectories
require_all 'lib'

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath

# Instantiate our Config object which collates the options and settings used
# by Quke or its dependencies, from environment variables, the config.yml file
# and any defaults Quke uses.
$config = Quke::Config.new
Capybara.app_host = $config.app_host

# The choice of which browser to use for the tests is dependent on what the
# config option DRIVER is set to. If not set we default to using
# phantomjs (which in turn drives poltergiest)
driver = case $config.driver
         when 'firefox'
           Quke::DriverRegistration.firefox
         when 'chrome'
           Quke::DriverRegistration.chrome
         when 'browserstack'
           Quke::DriverRegistration.browserstack($config.browserstack)
         else
           Quke::DriverRegistration.phantomjs($config.phantomjs_options)
         end

Capybara.default_driver = driver
Capybara.javascript_driver = driver

# By default Capybara will try to boot a rack application automatically. This
# switches off Capybara's rack server as we are running against a remote
# application.
Capybara.run_server = false

# When calling save_and_open_page the current html page is saved to file for
# debug purposes. This can be done directly within a step or happens
# automatically in the event of an error when using the selenium driver.
# Not setting this leads to Capybara saving the file to the root of the project
# which can get in the way when trying to work with Quke in your projects.
Capybara.save_path = 'tmp/'

# By default, SitePrism element and section methods do not utilize Capybara's
# implicit wait methodology and will return immediately if the element or
# section requested is not found on the page. Adding the following code
# enables Capybara's implicit wait methodology to pass through
SitePrism.configure do |config|
  config.use_implicit_waits = true
end
