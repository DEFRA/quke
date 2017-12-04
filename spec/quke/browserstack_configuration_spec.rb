require 'spec_helper'

RSpec.describe Quke::BrowserstackConfiguration do
  describe 'instantiating' do
    context 'when `.config.yml` is blank or contains no browserstack section' do
      let(:config) do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns an instance defaulted to blank values' do
        expect(subject.username).to eq('')
        expect(subject.auth_key).to eq('')
        expect(subject.local_key).to eq('')
        expect(subject.capabilities).to eq({})
      end

    end

    context 'when `.config.yml` contains a browserstack section' do
      let(:config) do
        Quke::Configuration.file_location = data_path('.simple.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns an instance with properties that match the input' do
        expect(subject.username).to eq('jdoe')
        expect(subject.auth_key).to eq('123456789ABCDE')
        expect(subject.local_key).to eq('123456789ABCDE')
        expect(subject.capabilities).to eq(
          'build' => 'Version 1',
          'project' => 'Adding browserstack support',
          'browserstack.local' => true
        )
      end

    end
  end

  describe '#test_locally?' do
    context 'when `.config.yml` is blank or contains no browserstack section' do
      let(:config) do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns false' do
        expect(subject.test_locally?).to eq(false)
      end

    end

    context "when the driver is not set to 'browserstack' in `.config.yml`" do
      let(:config) do
        Quke::Configuration.file_location = data_path('.simple.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns false' do
        expect(subject.test_locally?).to eq(false)
      end

    end

    # Unlike some aspects of Quke's configuration where we handle users mixing
    # strings and booleans ('true' and true) for setting values, because the
    # browserstack capabilities are passed straight through we return false
    # in this scenario to reflect what browserstack's behaviour would be
    # i.e. it would fail to recognise that running locally is needed.
    context "when the driver is 'browserstack' and use local testing is set to 'true' (a string) in `.config.yml`" do
      let(:config) do
        Quke::Configuration.file_location = data_path('.as_string.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns false' do
        expect(subject.test_locally?).to eq(false)
      end

    end

    context "when the driver is 'browserstack' and use local testing is set to true in `.config.yml`" do
      let(:config) do
        Quke::Configuration.file_location = data_path('.browserstack.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns true' do
        expect(subject.test_locally?).to eq(true)
      end

    end
  end

  describe 'local_testing_args' do
    context 'when `.config.yml` is blank or contains no browserstack section' do
      let(:config) do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'defaults to a blank key, and our standard args for the local binary' do
        expect(subject.local_testing_args).to eq(
          'key' => '',
          'force' => 'true',
          'onlyAutomate' => 'true',
          'v' => 'true',
          'logfile' => File.join(Dir.pwd, '/tmp/bowerstack_local_log.txt')
        )
      end

    end

    context 'when `.config.yml` contains just proxy details' do
      let(:config) do
        Quke::Configuration.file_location = data_path('.proxy_basic.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'defaults to a blank key, our standard args for the local binary, plus the proxy values' do
        expect(subject.local_testing_args).to eq(
          'key' => '',
          'force' => 'true',
          'onlyAutomate' => 'true',
          'v' => 'true',
          'logfile' => File.join(Dir.pwd, '/tmp/bowerstack_local_log.txt'),
          'proxyHost' => '10.10.2.70',
          'proxyPort' => '8080'
        )
      end
    end

    context 'when `.config.yml` contains both browserstack and proxy details' do
      let(:config) do
        Quke::Configuration.file_location = data_path('.browserstack.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'defaults to a blank key, our standard args for the local binary, plus the proxy values' do
        expect(subject.local_testing_args).to eq(
          'key' => '123456789ABCDE',
          'force' => 'true',
          'onlyAutomate' => 'true',
          'v' => 'true',
          'logfile' => File.join(Dir.pwd, '/tmp/bowerstack_local_log.txt'),
          'proxyHost' => '10.10.2.70',
          'proxyPort' => '8080'
        )
      end

    end
  end

  describe '#using_browserstack?' do
    context 'when `.config.yml` is blank' do
      let(:config) do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns false' do
        expect(subject.using_browserstack?).to eq(false)
      end

    end

    context "when `.config.yml` DOES NOT specify 'browserstack' as the driver" do
      let(:config) do
        Quke::Configuration.file_location = data_path('.simple.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns false' do
        expect(subject.using_browserstack?).to eq(false)
      end
    end

    context "when `.config.yml` specifies 'browserstack' as the driver" do
      let(:config) do
        Quke::Configuration.file_location = data_path('.browserstack.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns true' do
        expect(subject.using_browserstack?).to eq(true)
      end

    end
  end

  describe '#url' do

    context 'when `.config.yml` is blank or contains no browserstack section' do
      let(:config) do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns nil' do
        expect(subject.url).to eq(nil)
      end
    end

    context 'when `.config.yml` contains a browserstack section' do
      let(:config) do
        Quke::Configuration.file_location = data_path('.browserstack.yml')
        Quke::Configuration.new
      end
      subject { Quke::BrowserstackConfiguration.new(config) }

      it 'returns a string for the url to browserstack including the username and password' do
        expect(subject.url).to eq(
          'http://jdoe:123456789ABCDE@hub.browserstack.com/wd/hub'
        )
      end
    end

  end
end
