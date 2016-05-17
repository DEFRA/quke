require 'rspec/expectations'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'site_prism'

# To run the scenarios in browser (default: Firefox), use the following
# command line:
# bundle exec cucumber
# or (to have a pause of 1 second between each step):
# PAUSE=1 bundle exec cucumber
# To use chrome instead of Firefox
# DRIVER=chrome bundle exec cucumber
# Else the default will use the poltergiest headless browser
# bundle exec cucumber
#
# N.B. Initially the env var was named BROWSER but it was found this was
# a key environment variable for Launchy and changing it broke Launchy.
# Therefore have settled in DRIVER as a replacement, though its not as
# clear to quke's intended audience.

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath

# Here we are registering the poltergeist driver with capybara. There are a
# number of options for how to configure poltergeist, and we can even pass
# on options to phantomjs to configure how it runs
Capybara.register_driver :poltergeist do |app|
  options = {
    # Javascript errors will get re-raised in our tests causing them to fail
    js_errors: true,
    # How long in seconds we'll wait for response when communicating with
    # Phantomjs
    timeout: 30,
    # When true debug output will be logged to STDERR (a terminal thing!)
    debug: false,
    # Options for phantomjs: Don't load images to help speed up the tests,
    phantomjs_options: [
      '--load-images=no',
      '--disk-cache=false',
      '--ignore-ssl-errors=yes'],
    inspector: true
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

# Here we are registering the selenium driver with capybara. By default
# selinium is setup to work with firefox hence we refer to it as :firefox
Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app)
end

# We're registering the selenium driver again, only this time we are
# configuring it to work with chrome.
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# The choice of which browser to use for the tests is dependent on what the
# environment variable DRIVER is set to. If not set we default to using
# poltergeist
# We capture the value as a global env var so if necessary choice of browser
# can be referenced elsewhere, for example in any debug output.
$driver = case (ENV['DRIVER'] || '').downcase.strip
          when 'firefox'
            :firefox
          when 'chrome'
            :chrome
          else
            :poltergeist
          end

Capybara.default_driver = $driver
Capybara.javascript_driver = $driver

# We capture the value as a global env var so if necessary length of time
# between page interactions can be referenced elsewhere, for example in any
# debug output.
$pause = (ENV['PAUSE'] || 0).to_i

SitePrism.configure do |config|
  config.use_implicit_waits = true
end
