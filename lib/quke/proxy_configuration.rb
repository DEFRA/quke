# frozen_string_literal: true

module Quke #:nodoc:

  # Manages all parallel configuration for Quke.
  class ProxyConfiguration

    attr_reader :host, :port, :no_proxy

    def initialize(data = {})
      @host = (data["host"] || "").downcase.strip
      @port = (data["port"] || "0").to_s.downcase.strip.to_i
      @no_proxy = (data["no_proxy"] || "").downcase.strip
    end

    # Return true if the +host+ value has been set in the +.config.yml+
    # file, else false.
    #
    # It is mainly used when determining whether to apply proxy server settings
    # to the different drivers when registering them with Capybara.
    def use_proxy?
      @host != ""
    end

  end

end
