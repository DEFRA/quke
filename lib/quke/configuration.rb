require 'yaml'

module Quke #:nodoc:

  # Manages all configuration for Quke.
  class Configuration

    attr_reader :file_location, :data

    class << self
      attr_writer :file_location
    end

    # Returns the expected root location of where Quke expects to find the
    # the config file.
    def self.file_location
      @file_location ||= File.expand_path(
        "../../#{file_name}",
        File.dirname(__FILE__)
      )
    end

    # Return the file name for the config file, either as set by the user in
    # an environment variable called `QCONFIG` or the default of +.config.yml+.
    def self.file_name
      ENV['QUKE_CONFIG'] || '.config.yml'
    end

    # When an instance is initialized it will automatically populate itself by
    # calling a private method +load_data()+.
    def initialize
      @data = load_data
    end

    # Returns the value set for +features_folder+.
    #
    # This will be passed to Cucumber by Quke when it executes the tests. It
    # tells Cucumber where the main features folder which contains the tests is
    # located. If not set in the +.config.yml+ file it defaults to 'features'.
    def features_folder
      @data['features_folder']
    end

    # Returns the value set for +app_host+.
    #
    # Normally Capybara expects to be testing an in-process Rack application,
    # but Quke is designed to talk to a remote host. Users of Quke can set
    # what this will be by setting +app_host+ in their +.config.yml+ file.
    # Capybara will then combine this with links you provide.
    #
    #     visit('/Main_Page')
    #     visit('/')
    #
    # This saves you from having to repeat the full url each time.
    def app_host
      @data['app_host']
    end

    # Returns the value set for +driver+.
    #
    # Tells Quke which browser to use for testing. Choices are firefox,
    # chrome browserstack and phantomjs, with the default being phantomjs.
    def driver
      @data['driver']
    end

    # Return the value set for +pause+.
    #
    # Add a pause (in seconds) between steps so you can visually track how the
    # browser is responding. Only useful if using a non-headless browser. The
    # default is 0.
    def pause
      @data['pause']
    end

    # Return the hash of +browserstack+ options.
    #
    # If you select the browserstack driver, there are a number of options you
    # can pass through to setup your browserstack tests, username and auth_key
    # being the critical ones.
    #
    # Please see https://www.browserstack.com/automate/capabilities for more
    # details.
    def browserstack
      @data['browserstack']
    end

    # The hash returned from this method is intended to used in a call to
    # Capybara::Poltergeist::Driver.new(app, options).
    #
    # There are a number of options for how to configure poltergeist which
    # drives PhantomJS, and it includes options passed to phantomjs to
    # configure how it runs.
    def poltergeist_options
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
    end

    # Override to_s to output the contents of Config as a readable string rather
    # than the standard object output you get.
    def to_s
      @data.to_s
    end

    private

    def phantomjs_options
      # Don't load images to help speed up the tests,
      [
        '--load-images=no',
        '--disk-cache=false',
        '--ignore-ssl-errors=yes'
      ]
    end

    def load_data
      data = default_data!(load_yml_data)
      data['browserstack'] = browserstack_data(data['browserstack'])
      data
    end

    # rubocop:disable Metrics/AbcSize
    def default_data!(data)
      data.merge(
        'features_folder' => (data['features'] || 'features').downcase.strip,
        'app_host' => (data['app_host'] || '').downcase.strip,
        'driver' =>   (data['driver'] || 'phantomjs').downcase.strip,
        'pause' =>    (data['pause'] || '0').to_s.downcase.strip.to_i
      )
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable Metrics/MethodLength
    def browserstack_data(data)
      data = {} if data.nil?
      data.merge(
        'username' => (ENV['BROWSERSTACK_USERNAME'] ||
                       data['username'] ||
                       ''
                      ),
        'auth_key' => (ENV['BROWSERSTACK_AUTH_KEY'] ||
                       data['auth_key'] ||
                       ''
                      )
      )
    end
    # rubocop:enable Metrics/MethodLength

    def load_yml_data
      if File.exist? self.class.file_location
        # YAML.load_file returns false if the file exists but is empty. So
        # added the || {} to ensure we always return a hash from this method
        YAML.load_file(self.class.file_location) || {}
      else
        {}
      end
    end

  end

end
