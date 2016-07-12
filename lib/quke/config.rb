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

    # The hash returned from this method is intended to used in a call to
    # Capybara::Poltergeist::Driver.new(app, options).
    # There are a number of options for how to configure poltergeist, and we can
    # even pass on options to phantomjs to configure how it runs
    def poltergeist_options
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
          '--ignore-ssl-errors=yes'],
        inspector: true
      }
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
    def load_data
      yml_data = load_yml_data
      yml_data.merge(
        'app_host' => (ENV['APP_HOST'] || yml_data['app_host'] || '')
                      .downcase.strip,
        'driver' =>   (ENV['DRIVER'] || yml_data['driver'] || '')
                      .downcase.strip,
        'pause' =>    (ENV['PAUSE'] || yml_data['pause'] || '0')
                      .downcase.strip.to_i
      )
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/AbcSize

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
