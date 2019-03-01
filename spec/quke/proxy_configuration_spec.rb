# frozen_string_literal: true

require "spec_helper"

RSpec.describe Quke::ProxyConfiguration do
  describe "instantiating" do
    context "when `.config.yml` is blank or contains no parallel section" do
      subject do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        Quke::Configuration.new.proxy
      end

      it "returns an instance defaulted to blank values" do
        expect(subject.host).to eq("")
        expect(subject.port).to eq(0)
        expect(subject.no_proxy).to eq("")
      end

    end

    context "when `.config.yml` contains a proxy section" do
      subject do
        Quke::Configuration.file_location = data_path(".proxy.yml")
        Quke::Configuration.new.proxy
      end

      it "returns an instance with properties that match the input" do
        expect(subject.host).to eq("10.10.2.70")
        expect(subject.port).to eq(8080)
        expect(subject.no_proxy).to eq("127.0.0.1,192.168.0.1")
      end

    end

    context "when `.config.yml` contains a proxy section where port is entered as a string" do
      subject do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        Quke::Configuration.new.proxy
      end

      it "returns an instance with port set as a number" do
        expect(subject.port).to eq(8080)
      end

    end
  end

  describe "#use_proxy?" do
    context "when the instance has been instantiated with no data" do
      subject { Quke::ProxyConfiguration.new }

      it "returns false" do
        expect(subject.use_proxy?).to eq(false)
      end
    end

    context "when the instance has been instantiated with 'host' set" do
      subject { Quke::ProxyConfiguration.new("host" => "10.10.2.70") }

      it "returns true" do
        expect(subject.use_proxy?).to eq(true)
      end
    end
  end

  describe "#firefox_settings" do
    context "when the instance has been instantiated with no data" do
      subject { Quke::ProxyConfiguration.new }

      it "returns an empty hash" do
        expect(subject.firefox_settings).to eq({})
      end
    end

    context "when the instance has been instantiated with everything but 'host'" do
      subject { Quke::ProxyConfiguration.new("port" => "8080", "no_proxy" => "127.0.0.1") }

      it "returns an empty hash" do
        expect(subject.firefox_settings).to eq({})
      end
    end

    context "when the instance has been instantiated with data" do
      subject do
        Quke::ProxyConfiguration.new(
          "host" => "10.10.2.70",
          "port" => "8080",
          "no_proxy" => "127.0.0.1"
        )
      end

      it "returns a correctly populated hash" do
        expect(subject.firefox_settings).to eq(
          http: "10.10.2.70:8080",
          ssl: "10.10.2.70:8080",
          no_proxy: "127.0.0.1"
        )
      end
    end
  end
end
