require 'yaml'

module Quke #:nodoc:

  # Manages all configuration for Quke.
  class Configuration

    # Access where the config file was loaded from for this instance of
    # Quke::Configuration.
    attr_reader :file_location

    # Access the loaded config data object directly
    attr_reader :data

    class << self
      # Class level setter for the location of the config file.
      #
      # There will only be one for each execution of Quke and it does not
      # support reading from another during execution. Hence we write this to
      # the class level and all instances of Quke::Configuration then inherit
      # this value.
      attr_writer :file_location
    end

    # Returns the expected root location of where Quke expects to find the
    # the config file.
    def self.file_location
      @file_location ||= "#{Dir.pwd}/#{file_name}"
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

    # Return the value set for +stop_on_error+.
    #
    # Specify whether Quke should stop all tests once an error occurs. Useful in
    # Continuous Integration (CI) environments where a quick Yes/No is
    # preferable to a detailed response.
    def stop_on_error
      # This use of Yaml.load to convert a string to a boolean comes from
      # http://stackoverflow.com/a/21804027/6117745
      YAML.load(@data['stop_on_error'])
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

    # Return the hash of +proxy+ server settings
    #
    # If your environment requires you to go via a proxy server you can
    # configure Quke to use it by setting the +host+ and +port+ in your config
    # file.
    def proxy
      @data['proxy']
    end

    # Return true if the +proxy: host+ value has been set in the +.config.yml+
    # file, else false.
    #
    # It is mainly used when determining whether to apply proxy server settings
    # to the different drivers when registering them with Capybara.
    def use_proxy?
      proxy['host'] == '' ? false : true
    end

    # Override to_s to output the contents of Config as a readable string rather
    # than the standard object output you get.
    def to_s
      @data.to_s
    end

    private

    def load_data
      data = default_data!(load_yml_data)
      data['browserstack'] = browserstack_data(data['browserstack'])
      data['proxy'] = proxy_data(data['proxy'])
      data
    end

    # rubocop:disable Metrics/AbcSize
    def default_data!(data)
      data.merge(
        'features_folder' => (data['features'] || 'features').downcase.strip,
        'app_host' =>        (data['app_host'] || '').downcase.strip,
        'driver' =>          (data['driver'] || 'phantomjs').downcase.strip,
        'pause' =>           (data['pause'] || '0').to_s.downcase.strip.to_i,
        'stop_on_error' =>   (data['stop_on_error'] || 'false').to_s.downcase.strip
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

    def proxy_data(data)
      data = {} if data.nil?
      data.merge(
        'host' => (data['host'] || '').downcase.strip,
        'port' => (data['port'] || '0').to_s.downcase.strip.to_i,
        'no_proxy' => (data['no_proxy'] || '').downcase.strip
      )
    end

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
