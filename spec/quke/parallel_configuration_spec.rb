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

    context "when `.config.yml` contains a parallel section where processes is entered as a string" do
      subject do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        Quke::Configuration.new.parallel
      end

      it "returns an instance processes set as a number" do
        expect(subject.processes).to eq(4)
      end

    end
  end

  describe "#command_args" do
    context "when the instance has been instantiated with no data" do
      subject do
        Quke::Configuration.file_location = data_path(".no-file.yml")
        Quke::Configuration.new.parallel
      end

      it "returns an array of default args for ParallelTests" do
        expect(subject.command_args).to match_array(
          [
            "features",
            "--type",
            "cucumber",
            "--serialize-stdout",
            "--combine-stderr",
            "--single",
            "--quiet",
            "--test-options",
            "--format pretty -r #{File.join(Dir.pwd, 'lib', 'features')} -r features"
          ]
        )
      end

    end

    context "when the instance has been instantiated with parallel enabled" do
      subject do
        Quke::Configuration.file_location = data_path(".parallel.yml")
        Quke::Configuration.new.parallel
      end

      it "returns an array without the args '--single' and '--quiet'" do
        args = subject.command_args
        expect(args).not_to include(["--single", "--quiet"])
      end

    end

    context "when the instance has been instantiated with group_by set" do
      subject do
        Quke::Configuration.file_location = data_path(".parallel.yml")
        Quke::Configuration.new.parallel
      end

      it "returns an array with the args '--group-by' and 'scenarios'" do
        args = subject.command_args
        expect(args).to include("--group-by", "scenarios")
      end

    end

    context "when the instance has been instantiated with processes set" do
      subject do
        Quke::Configuration.file_location = data_path(".parallel.yml")
        Quke::Configuration.new.parallel
      end

      it "returns an array with the args '-n' and '4'" do
        args = subject.command_args
        expect(args).to include("-n", "4")
      end

    end

    context "when the instance has been instantiated with processes set but parallel disabled" do
      subject do
        Quke::Configuration.file_location = data_path(".parallel_disabled.yml")
        Quke::Configuration.new.parallel
      end

      it "returns an array without the args '-n' and '4'" do
        args = subject.command_args
        expect(args).not_to include("-n", "4")
      end

    end

    context "when additional arguments are passed in" do
      let(:additional_args) { ["--tags", "@wip"] }
      subject do
        Quke::Configuration.file_location = data_path(".no-file.yml")
        Quke::Configuration.new.parallel
      end

      it "the last argument contains those values" do
        args = subject.command_args(additional_args)
        expect(args.last).to include(additional_args.join(" "))
      end

    end
  end
end
