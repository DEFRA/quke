require 'rspec/expectations'
require 'capybara/cucumber'
require 'quke/driver_registration'
require 'quke/configuration'

Capybara.app_host =
  Quke::Quke.config.app_host unless Quke::Quke.config.app_host.empty?

driver = Quke::DriverRegistration.new(Quke::Quke.config).register

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
# which can mess up your project structure.
Capybara.save_path = 'tmp/'
