# frozen_string_literal: true

require "spec_helper"

RSpec.describe Quke::Configuration do
  describe "#features_folder" do
    context "when specified NOT specified in config file" do
      it "defaults to 'features'" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.features_folder).to eq("features")
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".simple.yml")
        expect(subject.features_folder).to eq("spec")
      end
    end
  end

  describe "#app_host" do
    context "when NOT specified in the config file" do
      it "defaults to ''" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.app_host).to eq("")
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".simple.yml")
        expect(subject.app_host).to eq("http://localhost:4567")
      end
    end
  end

  describe "#driver" do
    context "when NOT specified in the config file" do
      it "defaults to 'chrome'" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.driver).to eq("chrome")
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".simple.yml")
        expect(subject.driver).to eq("chrome")
      end
    end
  end

  describe "#headless" do
    context "when NOT specified in the config file" do
      it "defaults to false" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.headless).to be(false)
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".headless.yml")
        expect(subject.headless).to be(true)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        described_class.file_location = data_path(".as_string.yml")
        expect(subject.headless).to be(true)
      end
    end
  end

  describe "#pause" do
    context "when NOT specified in the config file" do
      it "defaults to 0" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.pause).to eq(0)
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".simple.yml")
        expect(subject.pause).to eq(1)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        described_class.file_location = data_path(".as_string.yml")
        expect(subject.pause).to eq(1)
      end
    end
  end

  describe "#stop_on_error" do
    context "when NOT specified in the config file" do
      it "defaults to false" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.stop_on_error).to be(false)
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".simple.yml")
        expect(subject.stop_on_error).to be(true)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        described_class.file_location = data_path(".as_string.yml")
        expect(subject.stop_on_error).to be(true)
      end
    end
  end

  describe "#display_failures" do
    context "when NOT specified in the config file" do
      it "defaults to true" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.display_failures).to be(true)
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".display_failures.yml")
        expect(subject.display_failures).to be(false)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        described_class.file_location = data_path(".as_string.yml")
        expect(subject.display_failures).to be(false)
      end
    end
  end

  describe "#display_failures?" do
    context "when `headless` is false and `display_failures` is false" do
      it "returns false" do
        described_class.file_location = data_path(".display_failures.yml")
        expect(subject.display_failures?).to be(false)
      end
    end

    context "when `headless` is true and `display_failures` is false" do
      it "returns false" do
        described_class.file_location = data_path(".as_string.yml")
        expect(subject.display_failures?).to be(false)
      end
    end

    context "when `headless` is false and `display_failures` is true" do
      it "returns false" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.display_failures?).to be(true)
      end
    end

    context "when `headless` is true and `display_failures` is true" do
      it "returns false" do
        described_class.file_location = data_path(".should_display_failures.yml")
        expect(subject.display_failures?).to be(false)
      end
    end
  end

  describe "#max_wait_time" do
    context "when NOT specified in the config file" do
      it "defaults to whatever the Capybara default is" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.max_wait_time).to eq(Capybara.default_max_wait_time)
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".simple.yml")
        expect(subject.max_wait_time).to eq(3)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        described_class.file_location = data_path(".as_string.yml")
        expect(subject.max_wait_time).to eq(3)
      end
    end
  end

  describe "#user_agent" do
    context "when NOT specified in the config file" do
      it "defaults to ''" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.user_agent).to eq("")
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".user_agent.yml")
        expect(subject.user_agent).to eq("Mozilla/5.0 (MSIE 10.0; Windows NT 6.1; Trident/5.0)")
      end
    end
  end

  describe "#print_progress" do
    context "when NOT specified in the config file" do
      it "defaults to false" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.print_progress).to be(false)
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        described_class.file_location = data_path(".print_progress.yml")
        expect(subject.print_progress).to be(true)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        described_class.file_location = data_path(".as_string.yml")
        expect(subject.print_progress).to be(true)
      end
    end
  end

  describe "#custom" do
    context "when NOT specified in the config file" do
      it "defaults to nothing" do
        described_class.file_location = data_path(".no_file.yml")
        expect(subject.custom).to be_nil
      end
    end

    context "when 'custom' in the config file holds simple key value pairs" do
      it "returns the key value pair if there is just one" do
        described_class.file_location = data_path(".custom_key_value_pair.yml")
        expect(subject.custom).to eq("my_key" => "my_value")
      end

      it "returns all key value pairs if there are multiples" do
        described_class.file_location = data_path(".custom_key_value_pairs.yml")
        expect(subject.custom).to eq(
          "my_key1" => "my_value1",
          "my_key2" => "my_value2",
          "my_key3" => "my_value3",
          "my_key4" => "my_value4",
          "my_key5" => "my_value5"
        )
      end
    end

    context "when 'custom' in the config file holds a hierachical object" do
      it "returns a representation of the object" do
        described_class.file_location = data_path(".custom_complex_object.yml")
        expect(subject.custom).to eq(
          "my_key" => "my_value",
          "accounts" => {
            "account1" => {
              "username" => "yoda",
              "password" => "greenisgood"
            },
            "account2" => {
              "username" => "vadar",
              "password" => "redrules"
            },
            "account3" => {
              "username" => "luke",
              "password" => "fatherissues"
            }
          },
          "troop_numbers" => {
            "dark_side_count" => 1_000_000,
            "light_side_count" => 5
          }
        )
      end
    end
  end

  describe "#cucumber_args" do
    let(:feature_folder_args) { ["features", "-r", File.join(Dir.pwd, "lib", "features"), "-r", "features"] }
    let(:format_pretty_args) { ["--format", "pretty"] }
    let(:format_progress_args) { ["--format", "progress"] }
    let(:fail_fast_args) { ["--fail-fast"] }
    let(:additional_args) { ["--tags", "@wip"] }
    let(:additional_whitespace_args) { [" --tags ", " @wip "] }

    context "when there are no additional arguments" do
      it "returns the default cucumber args value" do
        described_class.file_location = data_path(".no-file.yml")
        expect(subject.cucumber_args([])).to eq(format_pretty_args + feature_folder_args)
      end
    end

    context "when `stop_on_error` is true" do
      it "returns the default cucumber arg values including the '--fail-fast' option" do
        described_class.file_location = data_path(".stop_on_error.yml")

        expect(subject.cucumber_args([])).to eq(format_pretty_args + fail_fast_args + feature_folder_args)
      end
    end

    context "when `print_progress` is true" do
      it "returns the default cucumber arg values including the '--format progress' option" do
        described_class.file_location = data_path(".print_progress.yml")
        expect(subject.cucumber_args([])).to eq(format_progress_args + feature_folder_args)
      end
    end

    context "when there are additional arguments" do
      it "returns the default cucumber arg values plus the arguments" do
        described_class.file_location = data_path(".no-file.yml")
        expect(subject.cucumber_args(additional_args)).to eq(format_pretty_args + feature_folder_args + additional_args)
      end

      context "and some arguments have whitespace around them" do
        it "returns the default cucumber arg values plus the arguments without whitespace" do
          described_class.file_location = data_path(".no-file.yml")
          expect(subject.cucumber_args(additional_whitespace_args)).to eq(format_pretty_args + feature_folder_args + additional_args)
        end
      end
    end
  end

  describe ".file_name" do
    context "environment variable not set" do
      it "returns the default value '.config.yml'" do
        expect(described_class.file_name).to eq(".config.yml")
      end
    end
  end
end
