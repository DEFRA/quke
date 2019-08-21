# frozen_string_literal: true

require "quke/configuration"
require "selenium/webdriver"

module Quke #:nodoc:

  # Helper class that contains all methods related to registering drivers with
  # Capybara.
  class DriverRegistration

    # Access the instance of Quke::DriverConfiguration passed to this instance
    # of Quke::DriverRegistration when it was initialized.
    attr_reader :driver_config

    # Access the instance of Quke::Configuration passed to this instance of
    # Quke::DriverOptions when it was initialized.
    attr_reader :config

    # Instantiate an instance of Quke::DriverRegistration.
    #
    # It expects an instance of Quke::DriverConfiguration which will detail the
    # driver to be used and any related options, and Quke::Configuration
    # specifically for access to the browserstack config.
    def initialize(driver_config, config)
      @driver_config = driver_config
      @config = config
    end

    # When called registers with Capybara the driver specified.
    def register(driver)
      case driver
      when "firefox"
        firefox
      when "chrome"
        chrome
      when "browserstack"
        browserstack
      else
        chrome
      end
    end

    private

    # Register the selenium driver with capybara. By default selinium is setup
    # to work with firefox hence we refer to it as :firefox
    def firefox
      # For future reference configuring Firefox via Selenium appears to be done
      # via the options argument, and a Selenium::WebDriver::Firefox::Options
      # object.
      # https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings
      # https://www.rubydoc.info/gems/selenium-webdriver/3.141.0/Selenium/WebDriver/Firefox/Options
      # http://www.seleniumhq.org/docs/04_webdriver_advanced.jsp
      # http://preferential.mozdev.org/preferences.html
      Capybara.register_driver :firefox do |app|
        # :simplecov_ignore:
        Capybara::Selenium::Driver.new(
          app,
          browser: :firefox,
          options: @driver_config.firefox
        )
        # :simplecov_ignore:
      end
      :firefox
    end

    # Register the selenium driver again, only this time we are configuring it
    # to work with chrome.
    def chrome
      # For future reference configuring Chrome via Selenium appears to be done
      # use the options argument, which I understand is essentially passed by
      # Capybara to Selenium-webdriver, which in turn passes it to chromium
      # https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings
      # http://peter.sh/experiments/chromium-command-line-switches/
      # https://www.chromium.org/developers/design-documents/network-settings
      Capybara.register_driver :chrome do |app|
        # :simplecov_ignore:
        Capybara::Selenium::Driver.new(
          app,
          browser: :chrome,
          options: @driver_config.chrome
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
          url: @config.browserstack.url,
          desired_capabilities: @driver_config.browserstack
        )
        # :simplecov_ignore:
      end
      :browserstack
    end

  end

end
