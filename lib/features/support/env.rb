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

# We need bs_local to be declared outside of the AfterConfiguration block below
# so that it's available in the at_exit block.
# Did try simply calling it @bs_local inside the AfterConfiguration but that
# just kept causing Quke to crash immediately (shrug!)
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

# There aren't specific hooks we can attach to that only get called once before
# and after all tests have run in Cucumber. Therefore the next best thing is to
# hook into the AfterConfiguration and at_exit blocks.
#
# As its name suggests, this gets called after Cucumber has been configured i.e.
# all the steps above are complete. Fortunately this is before the tests start
# running so its the best place for us to start up the browserstack local
# testing binary (if it's required)
AfterConfiguration do
  if Quke::Quke.config.browserstack.test_locally?
    bs_local = BrowserStack::Local.new

    # starts the Local instance with the required arguments via its management
    # API
    bs_local.start(Quke::Quke.config.browserstack.local_testing_args)
  end
end

# This is the very last thing Cucumber calls that we can hook onto. Typically
# used for final cleanup, we make use of it to kill our browserstack local
# testing binary, and update the status of the session in browserstack
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
    rescue StandardError => err
      puts err
    end
  end
  # rubocop:enable Style/GlobalVars
  if bs_local && Quke::Quke.config.browserstack.test_locally?
    # stop the local instance
    bs_local.stop
  end
end
