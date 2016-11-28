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
      Capybara.register_driver :phantomjs do |app|
        # We ignore the next line (and those like it in the subsequent methods)
        # from code coverage because we never actually execute them from Quke.
        # Capybara.register_driver takes a name and a &block, and holds it in a
        # hash. It executes the block from within Capybara when Cucumber is
        # called, all we're doing here is telling it what block (code) to
        # execute at that time.
        # :simplecov_ignore:
        Capybara::Poltergeist::Driver.new(app, poltergeist_options)
        # :simplecov_ignore:
      end
      :phantomjs
    end

    # Register the selenium driver with capybara. By default selinium is setup
    # to work with firefox hence we refer to it as :firefox
    def firefox
      Capybara.register_driver :firefox do |app|
        # :simplecov_ignore:
        if config.use_proxy?
          Capybara::Selenium::Driver.new(app, profile: proxy_profile)
        else
          Capybara::Selenium::Driver.new(app)
        end
        # :simplecov_ignore:
      end
      :firefox
    end

    # Register the selenium driver again, only this time we are configuring it
    # to work with chrome.
    def chrome
      Capybara.register_driver :chrome do |app|
        # :simplecov_ignore:
        if config.use_proxy?
          Capybara::Selenium::Driver.new(
            app,
            browser: :chrome,
            switches: ["--proxy-server=#{config.proxy['host']}:#{config.proxy['port']}"]
          )
        else
          Capybara::Selenium::Driver.new(app, browser: :chrome)
        end
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

    # The hash returned from this method is intended to used in a call to
    # Capybara::Poltergeist::Driver.new(app, options).
    #
    # There are a number of options for how to configure poltergeist which
    # drives PhantomJS, and it includes options passed to phantomjs to
    # configure how it runs.
    def poltergeist_options
      # This method only gets called when we actually register our driver, and
      # as that only gets called when we actually run Cucumber properly it makes
      # it difficult to test.
      # :simplecov_ignore:
      {
        # Javascript errors will get re-raised in our tests causing them to fail
        js_errors: true,
        # How long in seconds we'll wait for response when communicating with
        # Phantomjs
        timeout: 30,
        # When true debug output will be logged to STDERR (a terminal thing!)
        debug: false,
        # Poltergeist can pass on options for configuring phantomjs
        phantomjs_options: phantomjs_options,
        inspector: true
      }
      # :simplecov_ignore:
    end

    def phantomjs_options
      # This method only gets called when we actually register our driver, and
      # as that only gets called when we actually run Cucumber properly it makes
      # it difficult to test.
      # :simplecov_ignore:
      # Don't load images to help speed up the tests,
      options = [
        '--load-images=no',
        '--disk-cache=false',
        '--ignore-ssl-errors=yes'
      ]
      if config.use_proxy?
        options.push("--proxy=#{config.proxy['host']}:#{config.proxy['port']}")
      end
      puts options
      options
      # :simplecov_ignore:
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

    def proxy_profile
      # This method only gets called when we actually register our driver, and
      # as that only gets called when we actually run Cucumber properly it makes
      # it difficult to test.
      # :simplecov_ignore:
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile.proxy = Selenium::WebDriver::Proxy.new(
        http: "#{config.proxy['host']}:#{config.proxy['port']}",
        ssl: "#{config.proxy['host']}:#{config.proxy['port']}"
      )
      profile
      # :simplecov_ignore:
    end

  end

end
