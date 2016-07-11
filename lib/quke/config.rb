require 'yaml'

module Quke
  # Go away
  class Config
    class << self
      def file_location
        @file_location ||= File.expand_path(
          '../../config.yml',
          File.dirname(__FILE__)
        )
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

    private

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
    def load_data
      yml_data = load_yml_data
      yml_data.merge(
        'app_host' => (ENV['APP_HOST'] || yml_data['app_host'] || '').downcase.strip,
        'driver' => (ENV['DRIVER'] || yml_data['driver'] || '').downcase.strip,
        'pause' => (ENV['PAUSE'] || yml_data['pause'] || '0').downcase.strip.to_i
      )
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/AbcSize

    def load_yml_data
      if File.exist? self.class.file_location
        YAML.load_file self.class.file_location
      else
        {}
      end
    end
  end
end
