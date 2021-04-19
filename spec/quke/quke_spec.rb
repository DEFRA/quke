# frozen_string_literal: true

require "spec_helper"

RSpec.describe Quke do
  describe ".execute" do
    context "when the configured driver is 'chrome'" do
      before(:example) do
        Quke::Configuration.file_location = data_path(".chrome.yml")
        Quke::Quke.config = Quke::Configuration.new
      end

      it "does not raise an error when called with driver :chrome" do
        expect { Quke::Quke.execute }.not_to raise_error
      end
    end

    context "when the configured driver is 'firefox'" do
      before(:example) do
        Quke::Configuration.file_location = data_path(".firefox.yml")
        Quke::Quke.config = Quke::Configuration.new
      end

      it "does not raise an error when called with driver :firefox" do
        expect { Quke::Quke.execute }.not_to raise_error
      end
    end

    # TODO: This test is currently failing with the following reason
    # Could not connect to www.browserstack.com due to Network issues. Please
    # check your internet connection or if you are behind proxy please use our
    # proxy options. For more details
    # https://www.browserstack.com/local-testing#modifiers (BrowserStack::LocalException)
    # /Users/acruikshanks/.rbenv/versions/2.4.2/lib/ruby/gems/2.4.0/gems/browserstack-local-1.3.0/lib/browserstack/local.rb:95:in `start'
    #
    # We suspect that the gem now tries to make a connection to browserstack
    # each time, and us such requires a valid key. Stubbing the method in
    # question, resolves this issue.
    #
    # Another problem then appears in that the test then goes into an inifinite
    # loop. If we alter the test eg `expect(Quke::Quke.execute).to eq(true)`
    # then the loop goes away and the test behaves as expected.
    # However we're trying to ensure we can call Quke using the browserstack
    # driver and not get an error, so we want to keep the existing test.
    #
    # We have confirmed everything is working when Quke is used in a normal
    # project. So at this time we have decided to mark this test as pending
    # until we can devote more time to identifying a solution.
    context "when the configured driver is 'browserstack'", skip: "failing in test suite" do
      before(:example) do
        Quke::Configuration.file_location = data_path(".browserstack.yml")
        Quke::Quke.config = Quke::Configuration.new

        # require "browserstack/local"
        # allow_any_instance_of(BrowserStack::Local).to receive(:start).and_return(true)
      end

      it "does not raise an error when called with driver :browserstack" do
        expect { Quke::Quke.execute }.not_to raise_error
      end
    end

    context "when one of the tests errors" do
      before { expect(Cucumber::Cli::Main).to receive(:new).and_raise(SystemExit) }

      it "holds onto the errors and raises them at the end" do
        expect { Quke::Quke.execute }.to raise_error(Quke::QukeError, "At least one Cucumber test failed")
      end
    end
  end
end
