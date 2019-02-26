# frozen_string_literal: true

# Helpers methods for use in all rspec tests
module Helpers

  # Returns the full path to a named file in the 'data' folder, for example
  #
  #     data_path('.simple_config.yml') # "/Users/jsmith/freakin/data/.simple_config.yml"
  #
  def data_path(path)
    File.expand_path(path, data_root)
  end

  # Returns the full path to the 'data' folder in this project, for example
  #
  #     "/Users/jsmith/freakin/data"
  #
  def data_root
    File.expand_path("spec/data", Dir.pwd)
  end

  # Returns a string which contains all the preferences set in an instance of
  # Selenium::WebDriver::Firefox::Profile.
  #
  # Though we can set the properties of an Selenium::WebDriver::Firefox::Profile
  # it makes it bloody awkward (!) to read them back. For example we can set
  #
  #     profile = Selenium::WebDriver::Firefox::Profile.new
  #     profile.proxy = Selenium::WebDriver::Proxy.new(...)
  #
  # Because it has a writer method (+proxy=+). However there is no reader and
  # this appears to be the case for most of its properties.
  # https://github.com/SeleniumHQ/selenium/blob/master/rb/lib/selenium/webdriver/firefox/profile.rb
  #
  # However having checked how they have written their tests for this class
  # (https://github.com/SeleniumHQ/selenium/blob/master/rb/spec/integration/selenium/webdriver/firefox/profile_spec.rb)
  # we were able to find Selenium::WebDriver::Firefox::Profile has a method
  # called +layout_on_disk+ which writes the profile to files. The Selenium team
  # use a helper method in their specs which writes the profile to disk and then
  # reads `user.js` to a string. It then tests the values in the string.
  #
  # This helper method is a tweeked version of theirs to allow us to do the same
  # thing.
  def read_profile_preferences(profile)
    dir = profile.layout_on_disk
    File.read(File.join(dir, "user.js"))
  end
end
