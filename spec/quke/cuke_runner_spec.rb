# frozen_string_literal: true

require "spec_helper"

RSpec.describe Quke::CukeRunner do
  let(:default_args) do
    features_folder = __dir__.sub!("spec/quke", "lib/features")
    ["features", "--type", "cucumber", "--serialize-stdout", "--combine-stderr", "--single", "--quiet", "--test-options", "--format pretty -r #{features_folder} -r features "]
  end
  describe "#initialize" do
    context "no additional Cucumber arguments passed" do
      let(:subject) { Quke::CukeRunner.new }
      it "returns just the default args used by Quke" do
        expect(subject.args).to eq(default_args)
      end
    end
    context "additional Cucumber arguments passed" do
      let(:args) { ["--tags", "test"] }
      let!(:subject) { Quke::CukeRunner.new(args) }
      it "returns the default args plus those passed in" do
        expected_args = default_args
        expected_args[-1] = expected_args.last + args.join(" ")
        expect(subject.args).to eq(expected_args)
      end
    end
  end
end
