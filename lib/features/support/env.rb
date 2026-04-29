# frozen_string_literal: true

require "rspec/expectations"
require "capybara/cucumber"
require "site_prism"
require "quke/configuration"
require "quke/driver_configuration"
require "quke/driver_registration"
require "browserstack/local"
require "quke/browserstack_status_reporter"

Capybara.app_host = Quke::Quke.config.app_host unless Quke::Quke.config.app_host.empty?

driver_config = Quke::DriverConfiguration.new(Quke::Quke.config)
driver_reg = Quke::DriverRegistration.new(driver_config, Quke::Quke.config)
driver = driver_reg.register(Quke::Quke.config.driver)

bs_local = nil

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
Capybara.save_path = "tmp/"

# BeforeAll / AfterAll run exactly once around the entire test run (Cucumber 8+).
# We use BeforeAll to start the BrowserStack Local binary when local testing is
# enabled, and AfterAll to stop it cleanly inside Cucumber's lifecycle.
BeforeAll do
  if Quke::Quke.config.browserstack.test_locally?
    bs_local = BrowserStack::Local.new
    bs_local.start(Quke::Quke.config.browserstack.local_testing_args)
  end
end

AfterAll do
  bs_local&.stop
end

# Update the BrowserStack session status (pass/fail) after all tests complete.
at_exit do
  # Because of the way cucumber works everthing is made global. This also means
  # any variables we set also need to be made global so they can be accessed
  # across the scenarios.
  # rubocop:disable Style/GlobalVars
  if $fail_count && Quke::Quke.config.browserstack.using_browserstack?
    reporter = Quke::BrowserstackStatusReporter.new(Quke::Quke.config.browserstack)
    begin
      if $fail_count == 0
        puts reporter.passed($session_id)
      else
        puts reporter.failed($session_id)
      end
    rescue StandardError => e
      puts e
    end
  end
  # rubocop:enable Style/GlobalVars
end
