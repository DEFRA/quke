# frozen_string_literal: true

require "spec_helper"

RSpec.describe Quke::ParallelConfiguration do
  describe "instantiating" do
    context "when `.config.yml` is blank or contains no parallel section" do
      subject do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        Quke::Configuration.new.parallel
      end

      it "returns an instance defaulted to blank values" do
        expect(subject.enabled).to eq(false)
        expect(subject.group_by).to eq("default")
        expect(subject.processes).to eq(0)
      end

    end

    context "when `.config.yml` contains a parallel section" do
      subject do
        Quke::Configuration.file_location = data_path(".simple.yml")
        Quke::Configuration.new.parallel
      end

      it "returns an instance with properties that match the input" do
        expect(subject.enabled).to eq(true)
        expect(subject.group_by).to eq("scenarios")
        expect(subject.processes).to eq(4)
      end

    end
  end

  describe "#command_args" do
    let(:feature_folder) { "features" }
    let(:additional_args) { ["--tags", "@wip"] }

    context "when the instance has been instantiated with no data" do
      subject { Quke::ParallelConfiguration.new }

      it "returns an array of default args for ParallelTests" do
        expect(subject.command_args(feature_folder)).to match_array(
          [
            feature_folder,
            "--type",
            "cucumber",
            "--serialize-stdout",
            "--combine-stderr",
            "--single",
            "--quiet",
            "--test-options",
            "--format pretty -r #{File.join(Dir.pwd, 'lib', 'features')} -r #{feature_folder}"
          ]
        )
      end

    end

    context "when the instance has been instantiated with parallel enabled" do
      subject { Quke::ParallelConfiguration.new("enable" => "true") }

      it "returns an array without the args '--single' and '--quiet'" do
        args = subject.command_args(feature_folder)
        expect(args).not_to include(["--single", "--quiet"])
      end

    end

    context "when the instance has been instantiated with group_by set" do
      subject { Quke::ParallelConfiguration.new("group_by" => "scenarios") }

      it "returns an array with the args '--group-by' and 'scenarios'" do
        args = subject.command_args(feature_folder)
        expect(args).to include("--group-by", "scenarios")
      end

    end

    context "when the instance has been instantiated with processes set" do
      subject { Quke::ParallelConfiguration.new("processes" => "4") }

      it "returns an array with the args '-n' and '4'" do
        args = subject.command_args(feature_folder)
        expect(args).to include("-n", "4")
      end

    end

    context "when additional arguments are passed in" do
      subject { Quke::ParallelConfiguration.new }

      it "the last argument contains those values" do
        args = subject.command_args(feature_folder, additional_args)
        expect(args.last).to include(additional_args.join(" "))
      end

    end
  end
end
