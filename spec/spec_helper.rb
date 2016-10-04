require 'simplecov'
SimpleCov.start do
  # any custom configs like groups and filters can be here at a central place
  add_filter '/lib/features/support/env.rb'
  add_filter '/spec/'
  nocov_token 'simplecov_ignore'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'helpers'
require 'quke'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.include Helpers
end
