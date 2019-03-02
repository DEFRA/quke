# frozen_string_literal: true

require "spec_helper"

RSpec.describe Quke::Configuration do
  describe "#features_folder" do
    context "when specified NOT specified in config file" do
      it "defaults to 'features'" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.features_folder).to eq("features")
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".simple.yml")
        expect(subject.features_folder).to eq("spec")
      end
    end
  end

  describe "#app_host" do
    context "when NOT specified in the config file" do
      it "defaults to ''" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.app_host).to eq("")
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".simple.yml")
        expect(subject.app_host).to eq("http://localhost:4567")
      end
    end
  end

  describe "#driver" do
    context "when NOT specified in the config file" do
      it "defaults to 'phantomjs'" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.driver).to eq("phantomjs")
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".simple.yml")
        expect(subject.driver).to eq("chrome")
      end
    end
  end

  describe "#headless" do
    context "when NOT specified in the config file" do
      it "defaults to false" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.headless).to eq(false)
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".headless.yml")
        expect(subject.headless).to eq(true)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        expect(subject.headless).to eq(true)
      end
    end
  end

  describe "#pause" do
    context "when NOT specified in the config file" do
      it "defaults to 0" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.pause).to eq(0)
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".simple.yml")
        expect(subject.pause).to eq(1)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        expect(subject.pause).to eq(1)
      end
    end
  end

  describe "#stop_on_error" do
    context "when NOT specified in the config file" do
      it "defaults to false" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.stop_on_error).to eq(false)
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".simple.yml")
        expect(subject.stop_on_error).to eq(true)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        expect(subject.stop_on_error).to eq(true)
      end
    end
  end

  describe "#display_failures" do
    context "when NOT specified in the config file" do
      it "defaults to true" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.display_failures).to eq(true)
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".display_failures.yml")
        expect(subject.display_failures).to eq(false)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        expect(subject.display_failures).to eq(false)
      end
    end
  end

  describe "#display_failures?" do
    context "when `headless` is false and `display_failures` is false" do
      it "returns false" do
        Quke::Configuration.file_location = data_path(".display_failures.yml")
        expect(subject.display_failures?).to eq(false)
      end
    end

    context "when `headless` is true and `display_failures` is false" do
      it "returns false" do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        expect(subject.display_failures?).to eq(false)
      end
    end

    context "when `headless` is false and `display_failures` is true" do
      it "returns false" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.display_failures?).to eq(true)
      end
    end

    context "when `headless` is true and `display_failures` is true" do
      it "returns false" do
        Quke::Configuration.file_location = data_path(".should_display_failures.yml")
        expect(subject.display_failures?).to eq(false)
      end
    end
  end

  describe "#max_wait_time" do
    context "when NOT specified in the config file" do
      it "defaults to whatever the Capybara default is" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.max_wait_time).to eq(Capybara.default_max_wait_time)
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".simple.yml")
        expect(subject.max_wait_time).to eq(3)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        expect(subject.max_wait_time).to eq(3)
      end
    end
  end

  describe "#user_agent" do
    context "when NOT specified in the config file" do
      it "defaults to ''" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.user_agent).to eq("")
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".user_agent.yml")
        expect(subject.user_agent).to eq("Mozilla/5.0 (MSIE 10.0; Windows NT 6.1; Trident/5.0)")
      end
    end
  end

  describe "#javascrip_errors" do
    context "when NOT specified in the config file" do
      it "defaults to true" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.javascript_errors).to eq(true)
      end
    end

    context "when specified in config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".javascript_errors.yml")
        expect(subject.javascript_errors).to eq(false)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        expect(subject.javascript_errors).to eq(false)
      end
    end
  end

  describe "#print_progress" do
    context "when NOT specified in the config file" do
      it "defaults to false" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.print_progress).to eq(false)
      end
    end

    context "when specified in the config file" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".print_progress.yml")
        expect(subject.print_progress).to eq(true)
      end
    end

    context "when in the config file as a string" do
      it "matches the config file" do
        Quke::Configuration.file_location = data_path(".as_string.yml")
        expect(subject.print_progress).to eq(true)
      end
    end
  end

  describe "#custom" do
    context "when NOT specified in the config file" do
      it "defaults to nothing" do
        Quke::Configuration.file_location = data_path(".no_file.yml")
        expect(subject.custom).to be(nil)
      end
    end

    context "when 'custom' in the config file holds simple key value pairs" do
      it "returns the key value pair if there is just one" do
        Quke::Configuration.file_location = data_path(".custom_key_value_pair.yml")
        expect(subject.custom).to eq("my_key" => "my_value")
      end

      it "returns all key value pairs if there are multiples" do
        Quke::Configuration.file_location = data_path(".custom_key_value_pairs.yml")
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
        Quke::Configuration.file_location = data_path(".custom_complex_object.yml")
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

  describe "#cucumber_arg" do
    let(:default_arg) { "--format pretty -r #{File.join(Dir.pwd, 'lib', 'features')} -r features" }
    let(:additional_args) { ["--tags", "@wip"] }

    context "when there are no additional arguments" do
      it "returns the default cucumber arg value" do
        Quke::Configuration.file_location = data_path(".no-file.yml")
        expect(subject.cucumber_arg([])).to eq(default_arg)
      end
    end

    context "when `stop_on_error` is true" do
      it "returns the default cucumber arg value including the '--fail-fast' option" do
        Quke::Configuration.file_location = data_path(".stop_on_error.yml")
        expect(subject.cucumber_arg([])).to eq("--fail-fast #{default_arg}")
      end
    end

    context "when `print_progress` is true" do
      it "returns the default cucumber arg value including the '--format progress' option" do
        Quke::Configuration.file_location = data_path(".print_progress.yml")
        expect(subject.cucumber_arg([])).to include("--format progress")
      end
    end

    context "when there are additional arguments" do
      it "returns the default cucumber arg value plus the arguments" do
        Quke::Configuration.file_location = data_path(".no-file.yml")
        expect(subject.cucumber_arg(additional_args)).to eq("#{default_arg} #{additional_args.join(' ')}")
      end
    end
  end

  describe ".file_name" do
    context "environment variable not set" do
      it "returns the default value '.config.yml'" do
        expect(Quke::Configuration.file_name).to eq(".config.yml")
      end
    end
  end
end
