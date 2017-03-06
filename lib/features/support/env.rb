require 'rspec/expectations'
require 'capybara/cucumber'
require 'site_prism'
require 'quke/configuration'
require 'quke/driver_configuration'
require 'quke/driver_registration'

unless Quke::Quke.config.app_host.empty?
  Capybara.app_host = Quke::Quke.config.app_host
end

driver_config = Quke::DriverConfiguration.new(Quke::Quke.config)
driver_reg = Quke::DriverRegistration.new(driver_config)
driver = driver_reg.register(Quke::Quke.config.driver)

Capybara.default_driver = driver
Capybara.javascript_driver = driver

# default_max_wait_time is the maximum time Capybara will wait for an element
# to appear. You may wish to override it if you are having to deal with a slow
# or unresponsive web site.
Capybara.default_max_wait_time = Quke::Quke.config.max_wait_time

# By default Capybara will try to boot a rack application automatically. This
# switches off Capybara's rack server as we are running against a remote
# application.
Capybara.run_server = false

# When calling save_and_open_page the current html page is saved to file for
# debug purposes. This can be done directly within a step or happens
# automatically in the event of an error when using the selenium driver.
# Not setting this leads to Capybara saving the file to the root of the project
# which can mess up your project structure.
Capybara.save_path = 'tmp/'

# By default, SitePrism element and section methods do not utilize Capybara's
# implicit wait methodology and will return immediately if the element or
# section requested is not found on the page. Adding the following code
# enables Capybara's implicit wait methodology to pass through
SitePrism.configure do |config|
  config.use_implicit_waits = true
end
