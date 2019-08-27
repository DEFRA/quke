# frozen_string_literal: true

require "selenium/webdriver"
require "webdrivers"
require "capybara"

require "quke/version"
require "quke/browserstack_configuration"
require "quke/browserstack_status_reporter"
require "quke/configuration"
require "quke/cuke_runner"
require "quke/driver_registration"
require "quke/driver_configuration"
require "quke/proxy_configuration"

module Quke #:nodoc:

  # The main Quke class. It is not intended to be instantiated and instead
  # just need to call its +execute+ method.
  class Quke

    class << self
      # Class level attribute which holds the instance of Quke::Configuration
      # used for the current execution of Quke.
      attr_accessor :config
    end

    # The entry point for Quke, it is the one call made by +exe/quke+.
    def self.execute(args = [])
      cuke = CukeRunner.new(args)
      cuke.run
    end

  end

end
