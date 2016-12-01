require 'spec_helper'

RSpec.describe Quke::DriverConfiguration do

  describe '#poltergeist' do

    context 'proxy details have NOT been set in the .config.yml' do
      it 'returns a hash containing only the default options' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).poltergeist).to eq(
          js_errors: true,
          timeout: 30,
          debug: false,
          phantomjs_options: [
            '--load-images=no',
            '--disk-cache=false',
            '--ignore-ssl-errors=yes'
          ],
          inspector: true
        )
      end
    end

    context 'proxy details have been set in the .config.yml' do
      it 'returns a hash containing both default options and proxy settings' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).poltergeist).to eq(
          js_errors: true,
          timeout: 30,
          debug: false,
          phantomjs_options: [
            '--load-images=no',
            '--disk-cache=false',
            '--ignore-ssl-errors=yes',
            "--proxy=#{config.proxy['host']}:#{config.proxy['port']}"
          ],
          inspector: true
        )
      end
    end

  end

  describe '#phantomjs' do

    context 'proxy details have NOT been set in the .config.yml' do
      it 'returns an array containing only the default options' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).phantomjs).to eq(
          [
            '--load-images=no',
            '--disk-cache=false',
            '--ignore-ssl-errors=yes'
          ]
        )
      end
    end

    context 'proxy details have been set in the .config.yml' do
      it 'returns an array containing both default options and proxy settings' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).phantomjs).to eq(
          [
            '--load-images=no',
            '--disk-cache=false',
            '--ignore-ssl-errors=yes',
            "--proxy=#{config.proxy['host']}:#{config.proxy['port']}"
          ]
        )
      end
    end

  end

  describe '#chrome' do

    context 'proxy details have NOT been set in the .config.yml' do
      it 'returns an empty array if no proxy has been set' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).chrome).to eq([])
      end
    end

    context 'basic proxy details have been set in the .config.yml' do
      it 'returns an array containing basic proxy settings' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).chrome).to eq(["--proxy-server=#{config.proxy['host']}:#{config.proxy['port']}"])
      end
    end

    context 'proxy details including addresses not to connect via the proxy server have been set in the .config.yml' do
      it 'returns an array containing proxy settings including no-proxy details' do
        Quke::Configuration.file_location = data_path('.proxy.yml')
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).chrome).to eq(
          [
            "--proxy-server=#{config.proxy['host']}:#{config.proxy['port']}",
            '--proxy-bypass-list=127.0.0.1;192.168.0.1'
          ]
        )
      end
    end

  end

  describe '#firefox' do

    context 'proxy details have NOT been set in the .config.yml' do
      it 'returns a profile where the proxy details are NOT set' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        config = Quke::Configuration.new
        profile = Quke::DriverConfiguration.new(config).firefox

        # See spec/helpers.rb#read_profile_preferences for details of why we
        # need to test the profile's properties in this way
        preferences = read_profile_preferences(profile)

        expect(preferences).not_to include('user_pref("network.proxy.http", "")')
        expect(preferences).not_to include('user_pref("network.proxy.http_port", 8080)')
      end
    end

    context 'basic proxy details have been set in the .config.yml' do
      it 'returns a profile where the basic proxy details are set' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        config = Quke::Configuration.new
        profile = Quke::DriverConfiguration.new(config).firefox

        # See spec/helpers.rb#read_profile_preferences for details of why we
        # need to test the profile's properties in this way
        preferences = read_profile_preferences(profile)

        expect(preferences).to include('user_pref("network.proxy.http", "10.10.2.70")')
        expect(preferences).to include('user_pref("network.proxy.http_port", 8080)')
      end
    end

    context 'proxy details including addresses not to connect via the proxy server have been set in the .config.yml' do
      it 'returns a profile where the proxy details are set including no-proxy details' do
        Quke::Configuration.file_location = data_path('.proxy.yml')
        config = Quke::Configuration.new
        profile = Quke::DriverConfiguration.new(config).firefox

        # See spec/helpers.rb#read_profile_preferences for details of why we
        # need to test the profile's properties in this way
        preferences = read_profile_preferences(profile)

        expect(preferences).to include('user_pref("network.proxy.http", "10.10.2.70")')
        expect(preferences).to include('user_pref("network.proxy.http_port", 8080)')
        expect(preferences).to include('user_pref("network.proxy.no_proxies_on", "127.0.0.1,192.168.0.1")')
      end
    end

  end

  describe '#browserstack_url' do

    context 'browserstack details have NOT been set in the .config.yml' do
      it 'returns nil' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).browserstack_url).to eq(nil)
      end
    end

    context 'browserstack details have been set in the .config.yml' do
      it 'returns a string for the url to browserstack including the username and password' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        config = Quke::Configuration.new
        expect(Quke::DriverConfiguration.new(config).browserstack_url).to eq(
          "http://#{config.browserstack['username']}:#{config.browserstack['auth_key']}@hub.browserstack.com/wd/hub"
        )
      end
    end

  end

  describe '#browserstack' do

    context 'browserstack details have NOT been set in the .config.yml' do
      it 'returns capabilities set to the browserstack defaults' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        config = Quke::Configuration.new
        capabilities = Quke::DriverConfiguration.new(config).browserstack

        expect(capabilities['build']).to eq(nil)
        expect(capabilities['project']).to eq(nil)
        expect(capabilities['name']).to eq(nil)
        expect(capabilities['platform']).to eq(nil)
        expect(capabilities['browserName']).to eq(nil)
        expect(capabilities['version']).to eq(nil)
        expect(capabilities['device']).to eq(nil)
        expect(capabilities['os']).to eq(nil)
        expect(capabilities['os_version']).to eq(nil)
        expect(capabilities['browser']).to eq(nil)
        expect(capabilities['browser_version']).to eq(nil)
        expect(capabilities['resolution']).to eq(nil)
        expect(capabilities['acceptSslCerts']).to eq(nil)
        expect(capabilities['browserstack.debug']).to eq(nil)
        expect(capabilities['browserstack.video']).to eq(nil)
        expect(capabilities['browserstack.local']).to eq('false')
      end
    end

    context 'browserstack details have been set in the .config.yml' do
      it 'returns capabilities that match those set' do
        Quke::Configuration.file_location = data_path('.browserstack.yml')
        config = Quke::Configuration.new
        capabilities = Quke::DriverConfiguration.new(config).browserstack

        expect(capabilities['build']).to eq('Version 1')
        expect(capabilities['project']).to eq('Adding browserstack support')
        expect(capabilities['name']).to eq('Testing google search')
        expect(capabilities['platform']).to eq('MAC')
        expect(capabilities['browserName']).to eq('iPhone')
        expect(capabilities['version']).to eq('49')
        expect(capabilities['device']).to eq('iPhone 5')
        expect(capabilities['os']).to eq('WINDOWS')
        expect(capabilities['os_version']).to eq('8.1')
        expect(capabilities['browser']).to eq('chrome')
        expect(capabilities['browser_version']).to eq('49')
        expect(capabilities['resolution']).to eq('1024x768')
        expect(capabilities['acceptSslCerts']).to eq(true)
        expect(capabilities['browserstack.debug']).to eq(true)
        expect(capabilities['browserstack.video']).to eq(true)
        expect(capabilities['browserstack.local']).to eq('false')
      end
    end

  end

end
