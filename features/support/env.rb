require 'rspec/expectations'
require 'capybara/cucumber'
require 'capybara/poltergeist'

# To run the scenarios in browser (default: Firefox), use the following
# command line:
# RUN_IN_BROWSER=true bundle exec cucumber
# or (to have a pause of 1 second between each step):
# RUN_IN_BROWSER=true PAUSE=1 bundle exec cucumber
# To use chrome instead of Firefox
# RUN_IN_BROWSER=true BROWSER=chrome bundle exec cucumber
# Else the default will use the poltergiest headless browser
# bundle exec cucumber

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

if ENV['RUN_IN_BROWSER']
  browser = case (ENV['BROWSER'] || 'firefox').downcase.strip
            when 'firefox'
              :firefox
            when 'chrome'
              :chrome
            else
              :firefox
            end

  Capybara.default_driver = browser
  Capybara.javascript_driver = browser
  AfterStep do
    sleep((ENV['PAUSE'] || 0).to_i)
  end
else
  Capybara.default_driver    = :poltergeist
  Capybara.javascript_driver = :poltergeist
end
