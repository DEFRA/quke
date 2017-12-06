module Quke #:nodoc:

  # Determines the configuration for browserstack, when selected as the driver
  class BrowserstackConfiguration
    # To run your tests with browserstack you must provide a username and
    # auth_key as a minimum.
    #
    # If the user doesn't put these credentials in the config file (because they
    # don't want to commit them to source control), Quke will also check for the
    # existance of the environment variables BROWSERSTACK_USERNAME and
    # BROWSERSTACK_AUTH_KEY and use them instead
    attr_reader :username, :auth_key

    # To use local testing users must provide a key. They will find this in
    # Browserstack once logged in under settings. Its typically the same value
    # as the auth_key above
    attr_reader :local_key

    # Capabilities are what configure the test in browserstack, for example
    # what OS and browser to use.
    #
    # Further reference on browserstack capabilities
    # https://www.browserstack.com/automate/capabilities
    # https://www.browserstack.com/automate/ruby#configure-capabilities
    attr_reader :capabilities

    # Returns a hash of configurations values that will be passed to the
    # +browserstack+ local binary when its started.
    #
    # The project uses the gem +browserstack-local+ to manage starting and
    # stopping the binary Browserstack provide for local testing. When started
    # you can configure how it behaviours by passing in a set of arguments as a
    # hash. This method generates the hash based on a mix of default values and
    # ones taken from the +.config.yml+.
    #
    # See https://github.com/browserstack/browserstack-local-ruby#arguments
    # https://www.browserstack.com/local-testing
    attr_reader :local_testing_args

    # Initialize's the instance based in the +Quke::Configuration+ instance
    # passed in.
    #
    # rubocop:disable Metrics/CyclomaticComplexity
    def initialize(configuration)
      @using_browserstack = configuration.data['driver'] == 'browserstack'
      data = validate_input_data(configuration.data)
      @username = ENV['BROWSERSTACK_USERNAME'] || data['username'] || ''
      @auth_key = ENV['BROWSERSTACK_AUTH_KEY'] || data['auth_key'] || ''
      @local_key = data['local_key'] || ''
      @capabilities = data['capabilities'] || {}
      determine_local_testing_args(configuration)
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    # Return true if the +browserstack.local: true+ value has been set in the
    # +.config.yml+ file and the driver is set to 'browserstack', else false.
    #
    # It is used when determing whether to start and stop the binary
    # Browserstack provides to support local testing.
    def test_locally?
      @capabilities['browserstack.local'] == true && using_browserstack?
    end

    # Returns true if the driver was set +browserstack+, else false.
    #
    # This class needs to know whether browserstack was selected as the driver
    # to use in order to correctly determine is the browserstack local testing
    # binary needs to be stopped and started for the tests.
    #
    # However it also serves as a clean and simple way ton determine if
    # browserstack is the selected dribver.
    def using_browserstack?
      @using_browserstack
    end

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
    #       url: my_config.browserstack_config.url,
    #       desired_capabilities: my_capabilites
    #     )
    #
    def url
      return "http://#{@username}:#{@auth_key}@hub.browserstack.com/wd/hub" unless @username == ''
    end

    private

    def validate_input_data(data)
      return {} if data.nil?
      return {} unless data['browserstack']
      data['browserstack']
    end

    def determine_local_testing_args(configuration)
      @local_testing_args = {
        # Key is the only required arg. Everything else is optional
        'key' => @local_key,
        # Always kill other running Browserstack Local instances
        'force' => 'true',
        # We only want to enable local testing for automate
        'onlyAutomate' => 'true',
        # Enable verbose logging. It's of no consequence to the tests, but it
        # could help in the event of errors
        'v' => 'true',
        # Rather than
        'logfile' => File.join(Dir.pwd, '/tmp/bowerstack_local_log.txt')
      }
      return unless configuration.use_proxy?

      @local_testing_args['proxyHost'] = configuration.proxy['host']
      @local_testing_args['proxyPort'] = configuration.proxy['port'].to_s
    end

  end

end
