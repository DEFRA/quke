# frozen_string_literal: true

require "simplecov"
require "simplecov-json"

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::JSONFormatter
  ]
)

# We start it with the rails param to ensure it includes coverage for all code
# started by the rails app, and not just the files touched by our unit tests.
# This gives us the most accurate assessment of our unit test coverage
# https://github.com/colszowka/simplecov#getting-started
unless SimpleCov.running
  SimpleCov.start("rails") do
    # We filter the spec folder, mainly to ensure that any dummy apps don't get
    # included in the coverage report. However our intent is that nothing in the
    # spec folder should be included
    add_filter "/spec/"
    # We filter the lib/features/support folder because the only way we can test
    # the code in there is to actually run Cucumber with a feature, something
    # we're currently trying to avoid in our tests.
    add_filter "/lib/features/support/"
    # The version file is simply just that, so we do not feel the need to ensure
    # we have a test for it
    add_filter "lib/quke/version"

    # You can make Simplecov ignore sections of code by wrapping them in # :nocov:
    # tags. However without knowledge of this `nocov` doesn't mean a lot so here
    # we take advantage of a feature that allows us to use a custom token to do
    # the same thing `nocov` does. Now in our code any sections we want to exclude
    # from test coverage stats we wrap in # :simplecov_ignore: tokens.
    # https://github.com/colszowka/simplecov#ignoringskipping-code
    nocov_token "simplecov_ignore"
  end
end
