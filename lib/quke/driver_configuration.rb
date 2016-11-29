require 'quke/configuration'

module Quke #:nodoc:

  # Helper class that manages the options, switches and capabilities for each of
  # the different drivers.
  class DriverConfiguration

    # Access the instance of Quke::Configuration passed to this instance of
    # Quke::DriverOptions when it was initialized.
    attr_reader :config

    # Instantiate an instance of Quke::DriverConfiguration.
    #
    # It expects an instance of Quke::Configuration which will be used
    # internally to determine how to set the options it passes back to each of
    # the drivers.
    # to be used and any related options
    def initialize(config)
      @config = config
    end

    # The hash returned from this method is intended to used  when initialising
    # an instance of Capybara::Poltergeist::Driver.
    #
    # For example when initialising the driver like this
    #
    #     Capybara::Poltergeist::Driver.new(app,
    #       {
    #         js_errors: true,
    #         timeout: 30,
    #         debug: false,
    #         phantomjs_options: [
    #           '--load-images=no',
    #           '--disk-cache=false',
    #           '--ignore-ssl-errors=yes',
    #           '--proxy=10.10.2.70:8080'
    #         ],
    #         inspector: true
    #       }
    #     )
    #
    # Rather than setting the options manually
    # Quke::DriverConfiguration.poltergeist is intended to manage what they
    # should be based on the properties of the Quke::Configuration instance its
    # initialised with
    #
    #     Capybara::Poltergeist::Driver.new(app, my_driver_config.poltergeist)
    #
    def poltergeist
      {
        # Javascript errors will get re-raised in our tests causing them to fail
        js_errors: true,
        # How long in seconds we'll wait for response when communicating with
        # Phantomjs
        timeout: 30,
        # When true debug output will be logged to STDERR (a terminal thing!)
        debug: false,
        # Poltergeist can pass on options for configuring phantomjs
        phantomjs_options: phantomjs,
        # The internet told me to put this here (???)
        inspector: true
      }
    end

    # Returns an array used as part of the poltergeist settings, which are
    # passed in when initialising a Capybara::Poltergeist::Driver.
    #
    # For example when initialising the driver like this
    #
    #     Capybara::Poltergeist::Driver.new(app,
    #       {
    #         js_errors: true,
    #         timeout: 30,
    #         debug: false,
    #         phantomjs_options: [
    #           '--load-images=no',
    #           '--disk-cache=false',
    #           '--ignore-ssl-errors=yes',
    #           '--proxy=10.10.2.70:8080'
    #         ],
    #         inspector: true
    #       }
    #     )
    #
    # Rather than setting the +phantomjs_options:+ manually
    # Quke::DriverConfiguration.phantomjs
    # is intended to manage what they should be based on the properties of the
    # Quke::Configuration instance its initialised with
    #
    #     Capybara::Poltergeist::Driver.new(app,
    #       {
    #         js_errors: true,
    #         timeout: 30,
    #         debug: false,
    #         phantomjs_options: my_driver_config.phantomjs,
    #         inspector: true
    #       }
    #     )
    #
    def phantomjs
      options = [
        '--load-images=no',
        '--disk-cache=false',
        '--ignore-ssl-errors=yes'
      ]
      if config.use_proxy?
        options.push("--proxy=#{config.proxy['host']}:#{config.proxy['port']}")
      end
      options
    end

    # Returns an array to be used in conjunction with the +:switches+ argument
    # when initialising a Capybara::Selenium::Driver set for Chrome.
    #
    # For example when initialising the driver like this
    #
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       browser: :chrome,
    #       switches: ["--proxy-server=localhost:8080"]
    #     )
    #
    # Rather than setting the switches manually Quke::DriverConfiguration.chrome
    # is intended to manage what they should be based on the properties of the
    # Quke::Configuration instance its initialised with
    #
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       browser: :chrome,
    #       switches: my_driver_config.chrome
    #     )
    #
    def chrome
      if config.use_proxy?
        ["--proxy-server=#{config.proxy['host']}:#{config.proxy['port']}"]
      else
        []
      end
    end

    # Returns an instance of Selenium::WebDriver::Remote::Capabilities to be
    # used when registering an instance of Capybara::Selenium::Driver,
    # configured to run using Firefox (the default).
    #
    # For example when initialising the driver like this
    #
    #     my_profile = Selenium::WebDriver::Firefox::Profile.new
    #     my_profile.proxy = Selenium::WebDriver::Proxy.new(
    #       http: "10.10.2.70:8080",
    #       ssl: "10.10.2.70:8080"
    #     )
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       profile: my_profile
    #     )
    #
    # You can instead call Quke::DriverConfiguration.firefox which will
    # manage instantiating and setting up the
    # Selenium::WebDriver::Firefox::Profile instance based on the
    # properties of the Quke::Configuration instance its initialised with
    #
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       profile: my_driver_config.firefox
    #     )
    #
    # rubocop:disable Metrics/AbcSize
    def firefox
      profile = Selenium::WebDriver::Firefox::Profile.new

      if config.use_proxy?
        profile.proxy = Selenium::WebDriver::Proxy.new(
          http: "#{config.proxy['host']}:#{config.proxy['port']}",
          ssl: "#{config.proxy['host']}:#{config.proxy['port']}"
        )
      end

      profile
    end
    # rubocop:enable Metrics/AbcSize

    # Returns a string representing the url used when running tests via
    # Browserstack[https://www.browserstack.com/] or nil.
    #
    # It will contain the username and auth_key set in the +.config.yml+, else
    # if +username+ is blank it will return nil.
    #
    # An example return value
    #
    #     "http://jdoe:123456789ABCDE@hub.browserstack.com/wd/hub"
    #
    # It is used when registering the driver with Capybara. So instead of this
    #
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       browser: :remote,
    #       url: 'http://jdoe:123456789ABCDE@hub.browserstack.com/wd/hub',
    #       desired_capabilities: my_capabilites
    #     )
    #
    # You can call +browserstack_url+ to get the url to use
    #
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       browser: :remote,
    #       url: my_driver_config.browserstack_url,
    #       desired_capabilities: my_capabilites
    #     )
    #
    def browserstack_url
      username = config.browserstack['username']
      key = config.browserstack['auth_key']
      return "http://#{username}:#{key}@hub.browserstack.com/wd/hub" unless username == ''
    end

    # Returns an instance of Selenium::WebDriver::Remote::Capabilities to be
    # used when registering an instance of Capybara::Selenium::Driver,
    # configured to run using the Browserstack[https://www.browserstack.com/]
    # service.
    #
    # For example when initialising the driver like this
    #
    #     my_capabilites = Selenium::WebDriver::Remote::Capabilities.new
    #     my_capabilites['build'] = my_config.browserstack['build']
    #     # ... set rest of capabilities
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       browser: :remote,
    #       url: 'http://jdoe:123456789ABCDE@hub.browserstack.com/wd/hub',
    #       desired_capabilities: my_capabilites
    #     )
    #
    # You can instead call Quke::DriverConfiguration.browserstack which will
    # manage instantiating and setting up the
    # Selenium::WebDriver::Remote::Capabilities instance based on the
    # properties of the Quke::Configuration instance its initialised with
    #
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       browser: :remote,
    #       url: my_driver_config.browserstack_url,
    #       desired_capabilities: my_driver_config.browserstack
    #     )
    #
    # For further reference on browserstack capabilities
    # https://www.browserstack.com/automate/capabilities
    # https://www.browserstack.com/automate/ruby#configure-capabilities
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def browserstack
      capabilities = Selenium::WebDriver::Remote::Capabilities.new

      capabilities['build'] = config.browserstack['build']
      capabilities['project'] = config.browserstack['project']
      capabilities['name'] = config.browserstack['name']

      # This and the following section are essentially diametric; you set one
      # or the other but not both. Some examples seem to put logic in place to
      # test the options passed in and then set the capabilities accordingly,
      # however Browserstack handles this and has what will happen documented
      # https://www.browserstack.com/automate/capabilities#capabilities-parameter-override
      capabilities['platform'] = config.browserstack['platform']
      capabilities['browserName'] = config.browserstack['browserName']
      capabilities['version'] = config.browserstack['version']
      capabilities['device'] = config.browserstack['device']

      capabilities['os'] = config.browserstack['os']
      capabilities['os_version'] = config.browserstack['os_version']
      capabilities['browser'] = config.browserstack['browser']
      capabilities['browser_version'] = config.browserstack['browser_version']
      capabilities['resolution'] = config.browserstack['resolution']
      # -----

      # This is not listed on the general capabilities page but is here
      # https://www.browserstack.com/automate/ruby#self-signed-certificates
      capabilities['acceptSslCerts'] = config.browserstack['acceptSslCerts']

      capabilities['browserstack.debug'] = config.browserstack['debug']
      capabilities['browserstack.video'] = config.browserstack['video']

      # At this point Quke does not support local testing so we specifically
      # tell Browserstack we're not doing this
      capabilities['browserstack.local'] = 'false'
      capabilities
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

  end

end