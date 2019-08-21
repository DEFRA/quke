# frozen_string_literal: true

require "spec_helper"

RSpec.describe Quke::DriverConfiguration do

  describe "#chrome" do

    context "proxy details have NOT been set in the .config.yml" do
      it "returns an instance of Chrome::Options where the proxy details are NOT set" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).chrome.args).to eq(Set[])
      end
    end

    context "basic proxy details have been set in the .config.yml" do
      it "returns an instance of Chrome::Options containing basic proxy settings" do
        Quke::Configuration.file_location = data_path(".proxy_basic.yml")
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).chrome.args).to eq(
          Set[
            "--proxy-server=#{config.proxy.host}:#{config.proxy.port}"
          ]
        )
      end
    end

    context "proxy details including addresses not to connect via the proxy server have been set in the .config.yml" do
      it "returns an instance of Chrome::Options containing proxy settings including no-proxy details" do
        Quke::Configuration.file_location = data_path(".proxy.yml")
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).chrome.args).to eq(
          Set[
            "--proxy-server=#{config.proxy.host}:#{config.proxy.port}",
            "--proxy-bypass-list=127.0.0.1;192.168.0.1"
          ]
        )
      end
    end

    context "a user agent has been set in the .config.yml" do
      it "returns an instance of Chrome::Options containing the specified user-agent" do
        Quke::Configuration.file_location = data_path(".user_agent.yml")
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).chrome.args).to eq(
          Set[
            "--user-agent=#{config.user_agent}"
          ]
        )
      end
    end

    context "headless mode has been set in the .config.yml" do
      it "returns an instance of Chrome::Options set to run the browser in headless mode" do
        Quke::Configuration.file_location = data_path(".headless.yml")
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).chrome.args).to eq(Set["--headless"])
      end
    end

  end

  describe "#firefox" do

    context "proxy details have NOT been set in the .config.yml" do
      it "returns an instance of Firefox::Options where the proxy details are NOT set" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        config = Quke::Configuration.new
        profile = Quke::DriverConfiguration.new(config).firefox.profile

        # See spec/helpers.rb#read_profile_preferences for details of why we
        # need to test the profile's properties in this way
        preferences = read_profile_preferences(profile)

        expect(preferences).not_to include('user_pref("network.proxy.http", "")')
        expect(preferences).not_to include('user_pref("network.proxy.http_port", 8080)')
      end
    end

    context "basic proxy details have been set in the .config.yml" do
      it "returns an instance of Firefox::Options containing basic proxy settings" do
        Quke::Configuration.file_location = data_path(".proxy_basic.yml")
        config = Quke::Configuration.new
        profile = Quke::DriverConfiguration.new(config).firefox.profile

        # See spec/helpers.rb#read_profile_preferences for details of why we
        # need to test the profile's properties in this way
        preferences = read_profile_preferences(profile)

        expect(preferences).to include('user_pref("network.proxy.http", "10.10.2.70")')
        expect(preferences).to include('user_pref("network.proxy.http_port", 8080)')
      end
    end

    context "proxy details including addresses not to connect via the proxy server have been set in the .config.yml" do
      it "returns an instance of Firefox::Options containing proxy settings including no-proxy details" do
        Quke::Configuration.file_location = data_path(".proxy.yml")
        config = Quke::Configuration.new
        profile = Quke::DriverConfiguration.new(config).firefox.profile

        # See spec/helpers.rb#read_profile_preferences for details of why we
        # need to test the profile's properties in this way
        preferences = read_profile_preferences(profile)

        expect(preferences).to include('user_pref("network.proxy.http", "10.10.2.70")')
        expect(preferences).to include('user_pref("network.proxy.http_port", 8080)')
        expect(preferences).to include('user_pref("network.proxy.no_proxies_on", "127.0.0.1,192.168.0.1")')
      end
    end

    context "a user agent has been set in the .config.yml" do
      it "returns an instance of Firefox::Options containing the specified user-agent" do
        Quke::Configuration.file_location = data_path(".user_agent.yml")
        config = Quke::Configuration.new
        profile = Quke::DriverConfiguration.new(config).firefox.profile

        # See spec/helpers.rb#read_profile_preferences for details of why we
        # need to test the profile's properties in this way
        preferences = read_profile_preferences(profile)

        expect(preferences).to include(
          'user_pref("general.useragent.override", "Mozilla/5.0 (MSIE 10.0; Windows NT 6.1; Trident/5.0)")'
        )
      end
    end

    context "headless mode has been set in the .config.yml" do
      it "returns an instance of Firefox::Options set to run the browser in headless mode" do
        Quke::Configuration.file_location = data_path(".headless.yml")
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).chrome.args).to eq(Set["--headless"])
      end
    end

  end

  describe "#browserstack" do

    context "browserstack details have NOT been set in the .config.yml" do
      it "returns capabilities set to Selenium::WebDriver::Remote::Capabilities defaults" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        config = Quke::Configuration.new
        capabilities = Quke::DriverConfiguration.new(config).browserstack

        expect(capabilities.as_json.keys.count).to eq(8)
        expect(capabilities["browserName"]).to eq(nil)
        expect(capabilities["version"]).to eq(nil)
        expect(capabilities["platform"]).to eq(nil)
        expect(capabilities["javascriptEnabled"]).to eq(nil)
        expect(capabilities["cssSelectorsEnabled"]).to eq(nil)
        expect(capabilities["takesScreenshot"]).to eq(nil)
        expect(capabilities["nativeEvents"]).to eq(nil)
        expect(capabilities["rotatable"]).to eq(nil)
      end
    end

    context "browserstack details have been set in the .config.yml" do
      it "returns capabilities that match those set" do
        Quke::Configuration.file_location = data_path(".browserstack.yml")
        config = Quke::Configuration.new
        capabilities = Quke::DriverConfiguration.new(config).browserstack
        expected_capabilities = YAML.load_file(data_path(".browserstack.yml"))["browserstack"]["capabilities"]

        expect(capabilities["build"]).to eq(expected_capabilities["build"])
        expect(capabilities["project"]).to eq(expected_capabilities["project"])
        expect(capabilities["name"]).to eq(expected_capabilities["name"])

        expect(capabilities["acceptSslCerts"]).to eq(expected_capabilities["acceptSslCerts"])
        expect(capabilities["browserstack.debug"]).to eq(expected_capabilities["browserstack.debug"])
        expect(capabilities["browserstack.video"]).to eq(expected_capabilities["browserstack.video"])
        expect(capabilities["browserstack.local"]).to eq(expected_capabilities["browserstack.local"])
        expect(capabilities["browserstack.maskSendKeys"]).to eq(expected_capabilities["browserstack.maskSendKeys"])

        expect(capabilities["platform"]).to eq(expected_capabilities["platform"])
        expect(capabilities["browserName"]).to eq(expected_capabilities["browserName"])
        expect(capabilities["version"]).to eq(expected_capabilities["version"])
        expect(capabilities["device"]).to eq(expected_capabilities["device"])
        expect(capabilities["os"]).to eq(expected_capabilities["os"])
        expect(capabilities["os_version"]).to eq(expected_capabilities["os_version"])
        expect(capabilities["browser"]).to eq(expected_capabilities["browser"])
        expect(capabilities["browser_version"]).to eq(expected_capabilities["browser_version"])
        expect(capabilities["resolution"]).to eq(expected_capabilities["resolution"])
      end
    end

  end

end
