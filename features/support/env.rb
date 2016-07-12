require 'rspec/expectations'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'site_prism'
require 'require_all'

# load all ruby files in the directory "lib" and its subdirectories
require_all 'lib'

# To run the scenarios in browser (default: Firefox), use the following
# command line:
# bundle exec cucumber
# or (to have a pause of 1 second between each step):
# PAUSE=1 bundle exec cucumber
# To use chrome instead of Firefox
# DRIVER=chrome bundle exec cucumber
# Else the default will use the poltergiest headless browser
# bundle exec cucumber
#
# N.B. Initially the env var was named BROWSER but it was found this was
# a key environment variable for Launchy and changing it broke Launchy.
# Therefore have settled in DRIVER as a replacement, though its not as
# clear to quke's intended audience.

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath

# Instantiate our Config object which collates the options and settings used
# by Quke or its dependencies, from environment variables, the config.yml file
# and any defaults Quke uses.
$config = Quke::Config.new
Capybara.app_host = $config.app_host

# Here we are registering the poltergeist driver with capybara. There are a
# number of options for how to configure poltergeist, and we can even pass
# on options to phantomjs to configure how it runs
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, $config.poltergeist_options)
end

# Here we are registering the selenium driver with capybara. By default
# selinium is setup to work with firefox hence we refer to it as :firefox
Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app)
end

# We're registering the selenium driver again, only this time we are
# configuring it to work with chrome.
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# The choice of which browser to use for the tests is dependent on what the
# environment variable DRIVER is set to. If not set we default to using
# poltergeist
# We capture the value as a global env var so if necessary choice of browser
# can be referenced elsewhere, for example in any debug output.
$driver = case $config.driver
          when 'firefox'
            :firefox
          when 'chrome'
            :chrome
          else
            :poltergeist
          end

Capybara.default_driver = $driver
Capybara.javascript_driver = $driver

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
