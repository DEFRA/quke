# frozen_string_literal: true

# Code coverage
require "simplecov"
SimpleCov.start do
  # any custom configs like groups and filters can be here at a central place

  # We filter the lib/features/support folder because the only way we can test
  # the code in there is to actually run Cucumber with a feature, something
  # we're currently trying to avoid in our tests.
  add_filter "/lib/features/support/"

  # It's standard to ignore the spec folder when determining coverage
  add_filter "/spec/"

  # You can make Simplecov ignore sections of by wrapping them in # :nocov:
  # tags. However without knowledge of this `nocov` doesn't mean a lot so here
  # we take advantage of a feature that allows us to use a custom token to do
  # the same thing `nocov` does. Now in our code any sections we want to exclude
  # from test coverage stats we wrap in # :simplecov_ignore: tokens.
  # https://github.com/colszowka/simplecov#ignoringskipping-code
  nocov_token "simplecov_ignore"
end

# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. However in a small gem like this the increase should be neglible
Dir[File.join(__dir__, "support", "**", "*.rb")].each { |f| require f }

require "helpers"
require "quke"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable the ability to run only selected tests. This means rather than
  # having to pass the specifics in at the command line we can denote which
  # tests we want to run in the code.
  # https://www.relishapp.com/rspec/rspec-core/docs/filtering/inclusion-filters
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.include Helpers
end
