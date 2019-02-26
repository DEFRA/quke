# frozen_string_literal: true

require "spec_helper"

RSpec.describe Quke::CukeRunner do
  let(:default_args) do
    features_folder = __dir__.sub!("spec/quke", "lib/features")
    ["spec", "-r", features_folder, "-r", "spec"]
  end
  describe "#initialize" do
    context "no additional Cucumber arguments passed" do
      let(:subject) { Quke::CukeRunner.new("spec") }
      it "returns just the default args used by Quke" do
        expect(subject.args).to eq(default_args)
      end
    end
    context "additional Cucumber arguments passed" do
      let(:args) { ["--tags", "test"] }
      let(:subject) { Quke::CukeRunner.new("spec", args) }
      it "returns the default args plus those passed in" do
        expect(subject.args).to eq(default_args + args)
      end
    end
  end

  describe "#run" do
    before(:example) do
      Quke::Configuration.file_location = data_path(".no_file.yml")
      Quke::Quke.config = Quke::Configuration.new
    end
    let(:subject) { Quke::CukeRunner.new("spec") }
    it "does not raise an error when called" do
      expect { subject.run }.not_to raise_error
    end
  end
end
