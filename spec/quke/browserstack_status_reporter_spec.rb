# frozen_string_literal: true

require "spec_helper"

RSpec.describe Quke::BrowserstackStatusReporter do
  subject do
    Quke::Configuration.file_location = data_path(".no_file.yml")
    config = Quke::BrowserstackConfiguration.new(Quke::Configuration.new)
    Quke::BrowserstackStatusReporter.new(config)
  end

  describe "#passed" do
    context "when the session_id is null" do
      it "raises an ArgumentError" do
        expect { subject.passed }.to raise_error(ArgumentError)
      end
    end

    context "when the session_id is valid" do
      before(:each) do
        stub_request(:put, /browserstack/)
          .with(
            body: /passed/,
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Authorization" => /Basic/,
              "Content-Type" => "application/json",
              "Host" => "www.browserstack.com",
              "User-Agent" => "Ruby"
            }
          )
          .to_return(status: 200, body: "", headers: {})
      end

      it "succesfully updates the status to 'passed'" do
        expect { subject.passed("6a22fe36d84d90ef18858f90f2c9cd2882eb082f") }.not_to raise_error
      end

      it "returns a message stating a given session's status was set to 'passed'" do
        result = subject.passed("6a22fe36d84d90ef18858f90f2c9cd2882eb082f")
        expect(result).to eq("Browserstack session 6a22fe36d84d90ef18858f90f2c9cd2882eb082f status set to \e[32mpassed\e[0m 😀")
      end
    end

    context "when the request fails" do
      before(:each) do
        stub_request(:put, /browserstack/)
          .with(
            body: /passed/,
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Authorization" => /Basic/,
              "Content-Type" => "application/json",
              "Host" => "www.browserstack.com",
              "User-Agent" => "Ruby"
            }
          )
          .to_return(status: 500, body: "", headers: {})
      end

      it "raises an error" do
        expect { subject.passed("6a22fe36d84d90ef18858f90f2c9cd2882eb082f") }.to raise_error(StandardError)
      end

    end
  end

  describe "#failed" do
    context "when the session_id is null" do
      it "raises an ArgumentError" do
        expect { subject.failed }.to raise_error(ArgumentError)
      end
    end

    context "when the session_id is valid" do
      before(:each) do
        stub_request(:put, /browserstack/)
          .with(
            body: /failed/,
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Authorization" => /Basic/,
              "Content-Type" => "application/json",
              "Host" => "www.browserstack.com",
              "User-Agent" => "Ruby"
            }
          )
          .to_return(status: 200, body: "", headers: {})
      end

      it "succesfully updates the status to 'failed'" do
        expect { subject.failed("6a22fe36d84d90ef18858f90f2c9cd2882eb082f") }.not_to raise_error
      end

      it "returns a message stating a given session's status was set to 'failed'" do
        result = subject.failed("6a22fe36d84d90ef18858f90f2c9cd2882eb082f")
        expect(result).to eq("Browserstack session 6a22fe36d84d90ef18858f90f2c9cd2882eb082f status set to \e[31mfailed\e[0m 😢")
      end

    end

    context "when the request fails" do
      before(:each) do
        stub_request(:put, /browserstack/)
          .with(
            body: /passed/,
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Authorization" => /Basic/,
              "Content-Type" => "application/json",
              "Host" => "www.browserstack.com",
              "User-Agent" => "Ruby"
            }
          )
          .to_return(status: 500, body: "", headers: {})
      end

      it "raises an error" do
        expect { subject.passed("6a22fe36d84d90ef18858f90f2c9cd2882eb082f") }.to raise_error(StandardError)
      end

    end

  end
end
