require 'yaml'

module Quke
  # Go away
  class Config
    class << self
      def file_location
        @file_location ||= File.expand_path(
          "../../#{file_name}",
          File.dirname(__FILE__)
        )
      end

      def file_name
        ENV['QCONFIG'] || '.config.yml'
      end
    end

    def initialize
      @data = load_data
    end

    def app_host
      @data['app_host']
    end

    def driver
      @data['driver']
    end

    def pause
      @data['pause']
    end

    def browserstack
      @data['browserstack']
    end

    # The hash returned from this method is intended to used in a call to
    # Capybara::Poltergeist::Driver.new(app, options).
    # There are a number of options for how to configure poltergeist which
    # drives PhantomJS, and we can even pass on options to phantomjs to
    # configure how it runs. We have named this function phantomjs_options
    # because it us used to setup the Capybara.register_driver :phantomjs in
    # features/support/env.rb
    def phantomjs_options
      {
        # Javascript errors will get re-raised in our tests causing them to fail
        js_errors: true,
        # How long in seconds we'll wait for response when communicating with
        # Phantomjs
        timeout: 30,
        # When true debug output will be logged to STDERR (a terminal thing!)
        debug: false,
        # Options for phantomjs: Don't load images to help speed up the tests,
        phantomjs_options: [
          '--load-images=no',
          '--disk-cache=false',
          '--ignore-ssl-errors=yes'
        ],
        inspector: true
      }
    end

    # Override to_s to output the contents of Config as a readable string rather
    # than the standard object output you get
    def to_s
      @data.to_s
    end

    private

    def load_data
      data = default_data!(load_yml_data)
      data['browserstack'] = browserstack_data(data['browserstack'])
      data
    end

    def default_data!(data)
      data.merge(
        'app_host' => (ENV['APP_HOST'] || data['app_host'] || '')
                      .downcase.strip,
        'driver' =>   (ENV['DRIVER'] || data['driver'] || 'phantomjs')
                      .downcase.strip,
        'pause' =>    (ENV['PAUSE'] || data['pause'] || '0')
                      .downcase.strip.to_i
      )
    end

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
