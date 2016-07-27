require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'selenium/webdriver'

module Quke
  # Helper class that contains all methods related to registering drivers with
  # Capybara.
  # Not only does this move the code out of features/support/env.rb, making that
  # easier to follow, it also makes it simpler to only register the driver
  # we intend to use, rather than registering them all but selecting only one
  # of them.
  # N.B. Another driver for this was having included the code to initialise the
  # the BrowserStack driver, even if it wasn't selected once registered it seems
  # Capaybara was always trying to use it.
  class DriverRegistration
    # Register the poltergeist driver with capybara. By default poltergeist is
    # setup to work with phantomjs hence we refer to it as :phantomjs
    # There are a number of options for how to configure poltergeist, and we can
    # even pass on options to phantomjs to configure how it runs
    def self.phantomjs(options = {})
      Capybara.register_driver :phantomjs do |app|
        Capybara::Poltergeist::Driver.new(app, options)
      end
      :phantomjs
    end

    # Register the selenium driver with capybara. By default selinium is setup
    # to work with firefox hence we refer to it as :firefox
    # N.B. options is not currently used but maybe in the future.
    def self.firefox(_options = {})
      Capybara.register_driver :firefox do |app|
        Capybara::Selenium::Driver.new(app)
      end
      :firefox
    end

    # Register the selenium driver again, only this time we are
    # configuring it to work with chrome.
    # N.B. options is not currently used but maybe in the future.
    def self.chrome(_options = {})
      Capybara.register_driver :chrome do |app|
        Capybara::Selenium::Driver.new(app, browser: :chrome)
      end
      :chrome
    end

    def self.browserstack(options = {})
      Capybara.register_driver :browserstack do |app|
        username = options['username']
        key = options['auth_key']
        url = "http://#{username}:#{key}@hub.browserstack.com/wd/hub"

        Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: url,
          desired_capabilities: browserstack_capabilities(options)
        )
      end
      :browserstack
    end

    private_class_method def self.browserstack_capabilities(options = {})
      capabilities = Selenium::WebDriver::Remote::Capabilities.new

      capabilities['build'] = options['build']
      capabilities['project'] = options['project']
      capabilities['name'] = options['name']

      # This and the following section are essentially diametric; you set one
      # or the other but not both. Some examples seen put logic in place to
      # test the options passed in and then set the capabilities accordingly,
      # however Browserstack handles this and has what will happen documented
      # https://www.browserstack.com/automate/capabilities#capabilities-parameter-override
      capabilities['platform'] = options['platform']
      capabilities['browserName'] = options['browserName']
      capabilities['version'] = options['version']

      capabilities['os'] = options['os']
      capabilities['os_version'] = options['os_version']
      capabilities['browser'] = options['browser']
      capabilities['browser_version'] = options['browser_version']
      # -----

      capabilities['browserstack.debug'] = options['debug']
      capabilities['browserstack.video'] = options['video']

      # At this point Quke does not support local testing so we specifically
      # tell Browserstack this
      capabilities['browserstack.local'] = 'false'
      capabilities
    end
  end
end
