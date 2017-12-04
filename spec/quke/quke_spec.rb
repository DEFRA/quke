require 'spec_helper'

RSpec.describe Quke do
  it 'has a version number' do
    expect(Quke::VERSION).not_to be nil
  end

  describe '.execute' do
    %i[firefox chrome browserstack phantomjs].each do |driver|
      before(:example) do
        Quke::Configuration.file_location = data_path(".#{driver}.yml")
        Quke::Quke.config = Quke::Configuration.new
      end

      it "does not raise an error when called with driver :#{driver}" do
        expect { Quke::Quke.execute }.not_to raise_error
      end
    end
  end
end
