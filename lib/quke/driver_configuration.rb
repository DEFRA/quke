# frozen_string_literal: true

require "quke/configuration"

module Quke # :nodoc:

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

    # Returns an instance of Selenium::WebDriver::Chrome::Options to be
    # used when registering an instance of Capybara::Selenium::Driver,
    # configured to run using Chrome.
    #
    # For example when initialising the driver like this
    #
    #     args = [
    #       "--proxy-server=localhost:8080",
    #       "--proxy-bypass-list=127.0.0.1,192.168.0.1",
    #       "--user-agent=Mozilla/5.0 (MSIE 10.0; Windows NT 6.1; Trident/5.0)"
    #     ]
    #
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       browser: :chrome,
    #       options: Selenium::WebDriver::Firefox::Options.new(args: args)
    #     )
    #
    # You can instead call Quke::DriverConfiguration.chrome which will
    # manage instantiating and setting up the
    # Selenium::WebDriver::Chrome::Options instance based on the
    # properties of the Quke::Configuration instance its initialised with
    #
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       browser: :chrome,
    #       options: my_driver_config.chrome
    #     )
    #
    def chrome
      no_proxy = config.proxy.no_proxy.tr(",", ";")

      args = config.headless ? ["--headless=new"] : []

      options = Selenium::WebDriver::Options.chrome(args: args)

      options.add_argument("--proxy-server=#{config.proxy.host}:#{config.proxy.port}") if config.proxy.use_proxy?
      options.add_argument("--proxy-bypass-list=#{no_proxy}") unless config.proxy.no_proxy.empty?

      options.add_argument("--user-agent=#{config.user_agent}") unless config.user_agent.empty?

      options
    end

    # Returns an instance of Selenium::WebDriver::Firefox::Options to be
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
    #       browser: :firefox,
    #       options: Selenium::WebDriver::Firefox::Options.new(profile: my_profile)
    #     )
    #
    # You can instead call Quke::DriverConfiguration.firefox which will
    # manage instantiating and setting up the
    # Selenium::WebDriver::Firefox::Options instance based on the
    # properties of the Quke::Configuration instance its initialised with
    #
    #     Capybara::Selenium::Driver.new(
    #       app,
    #       browser: :firefox,
    #       options: my_driver_config.firefox
    #     )
    #
    def firefox
      options = Selenium::WebDriver::Firefox::Options.new(profile: firefox_profile)
      options.headless! if config.headless

      options
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

      config.browserstack.capabilities.each do |key, value|
        capabilities[key] = value
      end

      capabilities
    end

    private

    def firefox_profile
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile["general.useragent.override"] = config.user_agent unless config.user_agent.empty?

      profile.proxy = Selenium::WebDriver::Proxy.new(config.proxy.firefox_settings) if config.proxy.use_proxy?

      profile
    end

  end

end
