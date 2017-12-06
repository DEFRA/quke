require 'spec_helper'

RSpec.describe Quke::DriverRegistration do
  describe '#register' do

    context 'A valid driver is passed to the method' do
      %i[firefox chrome browserstack phantomjs].each do |driver|
        it "returns the value :#{driver} when that driver is selected" do
          Quke::Configuration.file_location = data_path(".#{driver}.yml")
          config = Quke::Configuration.new
          driver_config = Quke::DriverConfiguration.new(config)
          driver_reg = Quke::DriverRegistration.new(driver_config, config)
          driver = driver_reg.register(config.driver)
          expect(driver).to eq(driver)
        end
      end
    end

    context 'An unrecognised driver is passed to the method' do
      it 'returns the default value :phantomjs' do
        Quke::Configuration.file_location = data_path('.invalid.yml')
        config = Quke::Configuration.new
        driver_config = Quke::DriverConfiguration.new(config)
        driver_reg = Quke::DriverRegistration.new(driver_config, config)
        driver = driver_reg.register(config.driver)
        expect(driver).to eq(driver)
      end
    end
  end

end
