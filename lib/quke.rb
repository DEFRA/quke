require 'quke/version'
require 'quke/configuration'
require 'quke/cuke_runner'
require 'quke/driver_registration'

module Quke #:nodoc:

  # The main Quke class. It is not intended to be instantiated and instead
  # just need to call its +execute+ method.
  class Quke

    class << self
      attr_accessor :config
    end

    # The entry point for Quke, it is the one call made by +exe/quke+.
    def self.execute(args = [])
      cuke = CukeRunner.new(@config.features_folder, args)
      cuke.run
    end

  end

end
