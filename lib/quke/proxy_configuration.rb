# frozen_string_literal: true

module Quke # :nodoc:

  # Manages all proxy configuration for Quke.
  class ProxyConfiguration

    # The host address for the proxy server
    attr_reader :host

    # The port number for the proxy server
    attr_reader :port

    # In some cases you may also need to tell the driver not to use the proxy for local
    # or specific connections. This returns a comma separated list of addresses of
    # those addresses if set.
    attr_reader :no_proxy

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

    # Returns a hash of settings specific to initialising a
    # +Selenium::WebDriver::Proxy+ instance, which will be created as part of
    # registering the Selenium firefox driver
    def firefox_settings
      settings = {}
      return settings unless use_proxy?

      settings[:http] = "#{host}:#{port}"
      settings[:ssl] = settings[:http]
      settings[:no_proxy] = no_proxy unless no_proxy.empty?

      settings
    end

  end

end
