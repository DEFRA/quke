require 'spec_helper'

RSpec.describe Quke::Configuration do
  describe '#features_folder' do
    context 'when specified NOT specified in config file' do
      it "defaults to 'features'" do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        expect(subject.features_folder).to eq('features')
      end
    end

    context 'when specified in config file' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        expect(subject.features_folder).to eq('spec')
      end
    end
  end

  describe '#app_host' do
    context 'when NOT specified in the config file' do
      it "defaults to ''" do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        expect(subject.app_host).to eq('')
      end
    end

    context 'when specified in config file' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        expect(subject.app_host).to eq('http://localhost:4567')
      end
    end
  end

  describe '#driver' do
    context 'when NOT specified in the config file' do
      it "defaults to 'phantomjs'" do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        expect(subject.driver).to eq('phantomjs')
      end
    end

    context 'when specified in the config file' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        expect(subject.driver).to eq('chrome')
      end
    end
  end

  describe '#pause' do
    context 'when NOT specified in the config file' do
      it 'defaults to 0' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        expect(subject.pause).to eq(0)
      end
    end

    context 'when specified in config file' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        expect(subject.pause).to eq(1)
      end
    end

    context 'when in the config file as a string' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.as_string.yml')
        expect(subject.pause).to eq(1)
      end
    end
  end

  describe '#stop_on_error' do
    context 'when NOT specified in the config file' do
      it 'defaults to false' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        expect(subject.stop_on_error).to eq(false)
      end
    end

    context 'when specified in config file' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        expect(subject.stop_on_error).to eq(true)
      end
    end

    context 'when in the config file as a string' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.as_string.yml')
        expect(subject.stop_on_error).to eq(true)
      end
    end
  end

  describe '#max_wait_time' do
    context 'when NOT specified in the config file' do
      it 'defaults to whatever the Capybara default is' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        expect(subject.max_wait_time).to eq(Capybara.default_max_wait_time)
      end
    end

    context 'when specified in config file' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        expect(subject.max_wait_time).to eq(3)
      end
    end

    context 'when in the config file as a string' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.as_string.yml')
        expect(subject.max_wait_time).to eq(3)
      end
    end
  end

  describe '#proxy' do
    context 'when NOT specified in the config file' do
      it 'defaults to a blank values' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        expect(subject.proxy).to eq('host' => '', 'port' => 0, 'no_proxy' => '')
      end
    end

    context 'when specified in the config file' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.proxy.yml')
        expect(subject.proxy).to eq(
          'host' => '10.10.2.70',
          'port' => 8080,
          'no_proxy' => '127.0.0.1,192.168.0.1'
        )
      end
    end

    context 'when port is specified in the config file as a string' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.as_string.yml')
        expect(subject.proxy).to eq(
          'host' => '',
          'port' => 8080,
          'no_proxy' => ''
        )
      end
    end
  end

  describe '#use_proxy?' do
    context 'when proxy host details are NOT specified in the config file' do
      it 'defaults to false' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        expect(subject.use_proxy?).to eq(false)
      end
    end

    context 'when proxy host details are specified in the config file' do
      it 'return true' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        expect(subject.use_proxy?).to eq(true)
      end
    end
  end

  describe '#browserstack' do
    context 'when NOT specified in the config file' do
      it 'defaults to a blank username and auth_key' do
        Quke::Configuration.file_location = data_path('.no_file.yml')
        expect(subject.browserstack).to eq('username' => '', 'auth_key' => '')
      end
    end

    context 'when specified in the config file' do
      it 'matches the config file' do
        Quke::Configuration.file_location = data_path('.simple.yml')
        expect(subject.browserstack).to eq(
          'username' => 'jdoe',
          'auth_key' => '123456789ABCDE',
          'build' => 'Version 1',
          'project' => 'Adding browserstack support'
        )
      end
    end
  end

  describe '#to_s' do
    it 'return the values held by the instance and not an instance ID' do
      Quke::Configuration.file_location = data_path('.no_file.yml')
      # rubocop:disable Style/StringLiterals
      expect(subject.to_s).to eq(
        "{\"features_folder\"=>\"features\", \"app_host\"=>\"\", \"driver\"=>\"phantomjs\", \"pause\"=>0, \"stop_on_error\"=>\"false\", \"max_wait_time\"=>2, \"browserstack\"=>{\"username\"=>\"\", \"auth_key\"=>\"\"}, \"proxy\"=>{\"host\"=>\"\", \"port\"=>0, \"no_proxy\"=>\"\"}}"
      )
      # rubocop:enable Style/StringLiterals
    end
  end

  describe '.file_name' do
    context 'environment variable not set' do
      it "returns the default value '.config.yml'" do
        expect(Quke::Configuration.file_name).to eq('.config.yml')
      end
    end
  end
end
