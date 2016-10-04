require 'spec_helper'

RSpec.describe Quke::DriverRegistration do
  describe '#register' do
    [:firefox, :chrome, :browserstack, :phantomjs].each do |driver|
      it "returns the value :#{driver} when that driver is selected" do
        Quke::Configuration.file_location = data_path(".#{driver}.yml")
        config = Quke::Configuration.new
        expect(Quke::DriverRegistration.new(config).register).to eq(driver)
      end
    end
  end
  describe '#browserstack_capabilities' do
    let(:subject) do
      Quke::Configuration.file_location = data_path('.browserstack.yml')
      config = Quke::Configuration.new
      Quke::DriverRegistration.new(config)
    end
    it 'returns and the right type' do
      return_val = subject.send(
        :browserstack_capabilities,
        username: 'jdoe',
        auth_key: '123456789ABCDE'
      )
      expect(return_val).to be_an_instance_of(
        Selenium::WebDriver::Remote::Capabilities
      )
    end
  end
end
