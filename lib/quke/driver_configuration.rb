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
      # The arguments we can pass to poltergeist are documented here
      # https://github.com/teampoltergeist/poltergeist#customization
      {
        # Javascript errors will get re-raised in our tests causing them to fail
        js_errors: config.javascript_errors,
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
      # For future reference the options we pass through to phantomjs appear to
      # mirror those you can actually supply on the command line.
      # http://phantomjs.org/api/command-line.html
      options = [
        '--load-images=no',
        '--disk-cache=false',
        '--ignore-ssl-errors=yes'
      ]

      options.push("--proxy=#{config.proxy['host']}:#{config.proxy['port']}") if config.use_proxy?

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
    #       switches: [
    #         "--proxy-server=localhost:8080",
    #         "--proxy-bypass-list=127.0.0.1,192.168.0.1",
    #         "--user-agent=Mozilla/5.0 (MSIE 10.0; Windows NT 6.1; Trident/5.0)"
    #       ]
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
    # rubocop:disable Metrics/AbcSize
    def chrome
      result = []

      host = config.proxy['host']
      port = config.proxy['port']
      no_proxy = config.proxy['no_proxy'].tr(',', ';')

      result.push("--proxy-server=#{host}:#{port}") if config.use_proxy?
      result.push("--proxy-bypass-list=#{no_proxy}") unless config.proxy['no_proxy'].empty?

      result.push("--user-agent=#{config.user_agent}") unless config.user_agent.empty?

      result
    end
    # rubocop:enable Metrics/AbcSize

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
    #     my_profile['general.useragent.override'] = "Mozilla/5.0 (MSIE 10.0; Windows NT 6.1; Trident/5.0)"
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

      settings = {}

      settings[:http] = "#{config.proxy['host']}:#{config.proxy['port']}" if config.use_proxy?
      settings[:ssl] = settings[:http] if config.use_proxy?
      settings[:no_proxy] = config.proxy['no_proxy'] unless config.proxy['no_proxy'].empty?

      profile.proxy = Selenium::WebDriver::Proxy.new(settings) if config.use_proxy?

      profile['general.useragent.override'] = config.user_agent unless config.user_agent.empty?

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
    def browserstack
      # Documentation and the code for this class can be found here
      # http://www.rubydoc.info/gems/selenium-webdriver/0.0.28/Selenium/WebDriver/Remote/Capabilities
      # https://github.com/SeleniumHQ/selenium/blob/master/rb/lib/selenium/webdriver/remote/capabilities.rb
      capabilities = Selenium::WebDriver::Remote::Capabilities.new

      browserstack_capabilities = config.browserstack['capabilities']

      browserstack_capabilities.each do |key, value|
        capabilities[key] = value
      end

      capabilities
    end

  end

end
