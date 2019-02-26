# frozen_string_literal: true

# Require and run our simplecov initializer as the very first thing we do.
# This is as per its docs https://github.com/colszowka/simplecov#getting-started
require "./spec/support/simplecov"

# Support debugging in the tests
require "byebug"

# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. However in a small gem like this the increase should be neglible
Dir[File.join(__dir__, "support", "**", "*.rb")].each { |f| require f }

# Need to require our actual code files
require "quke"

RSpec.configure do |config|
  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Enable the ability to run only selected tests. This means rather than
  # having to pass the specifics in at the command line we can denote which
  # tests we want to run in the code.
  # https://www.relishapp.com/rspec/rspec-core/docs/filtering/inclusion-filters
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Makes our helper methods available to all specs
  config.include Helpers
end
