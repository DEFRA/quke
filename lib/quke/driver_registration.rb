require 'quke/configuration'
require 'capybara/poltergeist'
require 'selenium/webdriver'

module Quke #:nodoc:

  # Helper class that contains all methods related to registering drivers with
  # Capybara.
  class DriverRegistration

    # Access the instance of Quke::Configuration passed to this instance of
    # Quke::DriverRegistration when it was initialized.
    attr_reader :config

    # Instantiate an instance of Quke::DriverRegistration.
    #
    # It expects an instance of Quke::Configuration which will detail the driver
    # to be used and any related options
    def initialize(config)
      @config = config
    end

    # When called registers the driver specified in the instance of
    # Quke::Configuration currently being used by Quke.
    def register
      case @config.driver
      when 'firefox'
        firefox
      when 'chrome'
        chrome
      when 'browserstack'
        browserstack(@config.browserstack)
      else
        phantomjs(@config.poltergeist_options)
      end
    end

    private

    # Register the poltergeist driver with capybara.
    #
    # By default poltergeist is setup to work with phantomjs hence we refer to
    # it as :phantomjs. There are a number of options for how to configure
    # poltergeist, and we can even pass on options to phantomjs to configure how
    # it runs.
    def phantomjs(options = {})
      Capybara.register_driver :phantomjs do |app|
        # We ignore the next line (and those like it in the subsequent methods)
        # from code coverage because we never actually execute them from Quke.
        # Capybara.register_driver takes a name and a &block, and holds it in a
        # hash. It executes the block from within Capybara when Cucumber is
        # called, all we're doing here is telling it what block (code) to
        # execute at that time.
        # :simplecov_ignore:
        Capybara::Poltergeist::Driver.new(app, options)
        # :simplecov_ignore:
      end
      :phantomjs
    end

    # Register the selenium driver with capybara. By default selinium is setup
    # to work with firefox hence we refer to it as :firefox
    #
    # N.B. options is not currently used but maybe in the future.
    def firefox(_options = {})
      Capybara.register_driver :firefox do |app|
        # :simplecov_ignore:
        Capybara::Selenium::Driver.new(app)
        # :simplecov_ignore:
      end
      :firefox
    end

    # Register the selenium driver again, only this time we are configuring it
    # to work with chrome.
    #
    # N.B. options is not currently used but maybe in the future.
    def chrome(_options = {})
      Capybara.register_driver :chrome do |app|
        # :simplecov_ignore:
        Capybara::Selenium::Driver.new(app, browser: :chrome)
        # :simplecov_ignore:
      end
      :chrome
    end

    # Register a browserstack driver. Essentially this the selenium driver but
    # configured to run remotely using the Browserstack automate service.
    # As a minimum the options must contain a username and key in order to
    # authenticate with Browserstack.
    # rubocop:disable Metrics/MethodLength
    def browserstack(options = {})
      Capybara.register_driver :browserstack do |app|
        # :simplecov_ignore:
        username = options['username']
        key = options['auth_key']
        url = "http://#{username}:#{key}@hub.browserstack.com/wd/hub"

        Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: url,
          desired_capabilities: browserstack_capabilities(options)
        )
        # :simplecov_ignore:
      end
      :browserstack
    end

    # rubocop:disable Metrics/AbcSize
    def browserstack_capabilities(options = {})
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
      # tell Browserstack we're not doing this
      capabilities['browserstack.local'] = 'false'
      capabilities
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

  end

end
