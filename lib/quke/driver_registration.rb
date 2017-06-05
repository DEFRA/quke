require 'quke/configuration'
require 'capybara/poltergeist'
require 'selenium/webdriver'

module Quke #:nodoc:

  # Helper class that contains all methods related to registering drivers with
  # Capybara.
  class DriverRegistration

    # Access the instance of Quke::DriverConfiguration passed to this instance
    # of Quke::DriverRegistration when it was initialized.
    attr_reader :config

    # Instantiate an instance of Quke::DriverRegistration.
    #
    # It expects an instance of Quke::DriverConfiguration which will detail the
    # driver to be used and any related options
    def initialize(config)
      @config = config
    end

    # When called registers with Capybara the driver specified.
    def register(driver)
      case driver
      when 'firefox'
        firefox
      when 'chrome'
        chrome
      when 'browserstack'
        browserstack
      else
        phantomjs
      end
    end

    private

    # Register the poltergeist driver with capybara.
    #
    # By default poltergeist is setup to work with phantomjs hence we refer to
    # it as :phantomjs. There are a number of options for how to configure
    # poltergeist, and we can even pass on options to phantomjs to configure how
    # it runs.
    def phantomjs
      # For future reference the options we pass through to phantomjs appear to
      # mirror those you can actually supply on the command line.
      # http://phantomjs.org/api/command-line.html
      # The arguments we can pass to poltergeist are documented here
      # https://github.com/teampoltergeist/poltergeist#customization
      Capybara.register_driver :phantomjs do |app|
        # We ignore the next line (and those like it in the subsequent methods)
        # from code coverage because we never actually execute them from Quke.
        # Capybara.register_driver takes a name and a &block, and holds it in a
        # hash. It executes the block from within Capybara when Cucumber is
        # called, all we're doing here is telling it what block (code) to
        # execute at that time.
        # :simplecov_ignore:
        Capybara::Poltergeist::Driver.new(app, config.poltergeist)
        # :simplecov_ignore:
      end
      :phantomjs
    end

    # Register the selenium driver with capybara. By default selinium is setup
    # to work with firefox hence we refer to it as :firefox
    def firefox
      # For future reference configuring Firefox via Selenium appears to be done
      # via the profile argument, and a Selenium::WebDriver::Firefox::Profile
      # object.
      # https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings#firefox
      # http://www.rubydoc.info/gems/selenium-webdriver/0.0.28/Selenium/WebDriver/Firefox/Profile
      # http://www.seleniumhq.org/docs/04_webdriver_advanced.jsp
      # http://preferential.mozdev.org/preferences.html
      Capybara.register_driver :firefox do |app|
        # :simplecov_ignore:
        Capybara::Selenium::Driver.new(app, profile: config.firefox)
        # :simplecov_ignore:
      end
      :firefox
    end

    # Register the selenium driver again, only this time we are configuring it
    # to work with chrome.
    def chrome
      # For future reference configuring Chrome via Selenium appears to be done
      # use the switches argument, which I understand is essentially passed by
      # Capybara to Selenium-webdriver, which in turn passes it to chromium
      # https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings#chrome
      # http://peter.sh/experiments/chromium-command-line-switches/
      # https://www.chromium.org/developers/design-documents/network-settings
      Capybara.register_driver :chrome do |app|
        # :simplecov_ignore:
        Capybara::Selenium::Driver.new(
          app,
          browser: :chrome,
          switches: config.chrome
        )
        # :simplecov_ignore:
      end
      :chrome
    end

    # Register a browserstack driver. Essentially this is the selenium driver
    # but configured to run remotely using the Browserstack automate service.
    # As a minimum the +.config.yml+ must contain a username and auth_key in
    # order to authenticate with Browserstack.
    def browserstack
      Capybara.register_driver :browserstack do |app|
        # :simplecov_ignore:
        Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: config.browserstack_url,
          desired_capabilities: config.browserstack
        )
        # :simplecov_ignore:
      end
      :browserstack
    end

  end

end
