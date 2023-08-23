# frozen_string_literal: true

require "selenium/webdriver"
require "capybara"

require "quke/version"
require "quke/browserstack_configuration"
require "quke/browserstack_status_reporter"
require "quke/configuration"
require "quke/cuke_runner"
require "quke/driver_registration"
require "quke/driver_configuration"
require "quke/proxy_configuration"

module Quke # :nodoc:

  class QukeError < StandardError; end

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
      errors = cuke.run
      return if errors.empty?

      raise QukeError.new, "Number of failures or errors: #{errors.count}"
    end

  end

end
