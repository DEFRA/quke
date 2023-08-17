# frozen_string_literal: true

require "yaml"

module Quke # :nodoc:

  # Manages all configuration for Quke.
  class Configuration

    # Access where the config file was loaded from for this instance of
    # Quke::Configuration.
    attr_reader :file_location

    # Access the loaded config data object directly.
    attr_reader :data

    # Instance of +Quke::BrowserstackConfiguration+ which manages reading and
    # returning the config for setting up Quke to use browserstack.
    attr_reader :browserstack

    # Instance of +Quke::ProxyConfiguration+ which manages reading and
    # returning the config for setting up Quke to use proxy server.
    attr_reader :proxy

    class << self
      # Class level setter for the location of the config file.
      #
      # There will only be one for each execution of Quke and it does not
      # support reading from another during execution. Hence we write this to
      # the class level and all instances of Quke::Configuration then inherit
      # this value.
      attr_writer :file_location
    end

    # Returns the expected root location of where Quke expects to find the
    # the config file.
    def self.file_location
      @file_location ||= "#{Dir.pwd}/#{file_name}"
    end

    # Return the file name for the config file, either as set by the user in
    # an environment variable called `QCONFIG` or the default of +.config.yml+.
    def self.file_name
      ENV["QUKE_CONFIG"] || ".config.yml"
    end

    # When an instance is initialized it will automatically populate itself by
    # calling a private method +default_data()+.
    def initialize
      @data = default_data!(load_yml_data)
      # Order is important. @browserstack relies on @proxy being set
      @proxy = ::Quke::ProxyConfiguration.new(@data["proxy"] || {})
      @browserstack = ::Quke::BrowserstackConfiguration.new(self)
    end

    # Returns the value set for +features_folder+.
    #
    # This will be passed to Cucumber by Quke when it executes the tests. It
    # tells Cucumber where the main features folder which contains the tests is
    # located. If not set in the +.config.yml+ file it defaults to 'features'.
    def features_folder
      @data["features_folder"]
    end

    # Returns the value set for +app_host+.
    #
    # Normally Capybara expects to be testing an in-process Rack application,
    # but Quke is designed to talk to a remote host. Users of Quke can set
    # what this will be by setting +app_host+ in their +.config.yml+ file.
    # Capybara will then combine this with links you provide.
    #
    #     visit('/Main_Page')
    #     visit('/')
    #
    # This saves you from having to repeat the full url each time.
    def app_host
      @data["app_host"]
    end

    # Returns the value set for +driver+.
    #
    # Tells Quke which browser to use for testing. Choices are firefox,
    # chrome, and browserstack, with the default being chrome.
    def driver
      @data["driver"]
    end

    # Returns the value set for +headless+.
    #
    # Tells Quke whether to drive the browser in headless mode. Only applicable
    # if +driver+ is set to 'chrome' or 'firefox'.
    def headless
      @data["headless"]
    end

    # Return the value set for +pause+.
    #
    # Add a pause (in seconds) between steps so you can visually track how the
    # browser is responding. Only useful if using a non-headless browser. The
    # default is 0.
    def pause
      @data["pause"]
    end

    # Return the value set for +stop_on_error+.
    #
    # Specify whether Quke should stop all tests once an error occurs. Useful in
    # Continuous Integration (CI) environments where a quick Yes/No is
    # preferable to a detailed response.
    def stop_on_error
      # This use of Yaml.load to convert a string to a boolean comes from
      # http://stackoverflow.com/a/21804027/6117745
      YAML.load(@data["stop_on_error"])
    end

    # Returns the value set for +display_failures+.
    #
    # Tells Quke not to display the html for the last page when a failure
    # happens. Quke uses Capybara to save a copy of the page as html and uses
    # launchy to display it in the default browser.
    def display_failures
      @data["display_failures"]
    end

    # Returns whether failures should be displayed.
    #
    # If the browser is headless then we never display failures, even if the
    # setting has been set to true. Else whether we display a failure is based
    # on the value set for display_failures.
    def display_failures?
      return false if headless

      display_failures
    end

    # Return the value for +max_wait_time+
    #
    # +max_wait_time+ is the time Capybara will spend waiting for an element
    # to appear. It's default is normally 2 seconds but you may want to increase
    # this is you are having to deal with a site that is not performant or prone
    # to delays.
    #
    # If the value is not set in config file, it will default to whatever is the
    # current Capybara value for default_max_wait_time.
    def max_wait_time
      @data["max_wait_time"]
    end

    # Return the value set for +user_agent+.
    #
    # Useful if you want the underlying driver to spoof what kind of browser the
    # request is coming from. For example you may want to pretend to be a mobile
    # browser so you can check what you get back versus the desktop version. Or
    # you want to pretend to be another kind of browser, because the one you
    # have is not supported by the site.
    def user_agent
      @data["user_agent"]
    end

    # Returns the value set for +print_progress+.
    #
    # If set Quke will tell Cucumber to output to the console using its
    # 'progress' formatter, rather than the default 'pretty' which displays each
    # scenario in detail.
    def print_progress
      @data["print_progress"]
    end

    # Return the hash of +custom+ server settings
    #
    # This returns a hash of all the key/values in the custom section of your
    # +.config.yml+ file. You can then access it in your steps/page objects with
    #
    #     Quke::Quke.config.custom["default_org_name"] # = "Testy Ltd"
    #     Quke::Quke.config.custom["accounts"]["account2"]["username"] # = "john.doe@example.gov.uk"
    #     Quke::Quke.config.custom["urls"]["front_office"] # = "http://myservice.service.gov.uk"
    #
    # As long as what you add is valid YAML (check with a tool like
    # http://www.yamllint.com/) Quke will be able to pick it up and make it
    # available in your tests.
    def custom
      @data["custom"]
    end

    # Returns an array containing the arguments to be passed to Cucumber.
    # These will be a combination of arguments we need to pass in to make
    # Cucumber recognise our +env.rb+ file, and the feature and step files from
    # the host project.
    #
    # A typical example of how Quke will formulate the arguments is
    #
    #     +--format pretty --fail-fast features -r /path_to_quke/quke/lib/features -r features --tags @wip+
    #
    # Broken down they are
    #
    # [--format]
    #   Options are +pretty+ or +progress+. Quke users control this via the
    #   +print_progress+ setting
    # [--fail-fast]
    #   If passed in it will tell Cucumber to stop running after the first
    # failure. Quke users control this via the +stop_on_error+ setting
    # [name of features folder]
    #   name of the users features folder (in most cases it'll just be
    #  +features+). Quke users control this via the +features_folder+ setting
    # [-r /path_to_quke/quke/lib/features]
    #   Tells Cucumber to require Quke's features folder. Because Cucumber is
    #   called in the context of the executing script it will take the next
    #   argument from that position, not from where the Quke gem currently sits.
    #   This means to Cucumber 'quke/lib/features' doesn't exist, which means
    #   our +env.rb+ never gets loaded. Instead we first have to determine where
    #   *this* file is running from when called. Then we replace the last part
    #   of that result (which we know will be +lib/quke+) with +lib/features+.
    #   We then pass this full path to Cucumber so it can correctly find the
    #   folder holding our predefined +env.rb+ file and our hooks.
    # [-r features]
    #   When using Cucumber directly if you wish to use a different folder from
    #   the default +features+, or wish to test specific features you are
    #   required to also specify the path to the folder in the args you pass in.
    #   In developing Quke we have found we always have to specify this argument
    #   to make Cucumber's tagging feature work when run from the context of
    #   Quke.
    # [--tags @wip]
    #   This is an example of the additional arguments that may be passed in by
    #   the user. Essentially anything after the last +-r+ argument to Cucumber
    #   are arguments pass into Quke by the user which we forward onto Cucumber.
    #
    # The additional args are whatever a user enters after the
    # `bundle exec quke` command.
    def cucumber_args(additional_args)
      args = ["--format", print_progress ? "progress" : "pretty"]
      args += ["--fail-fast"] if stop_on_error
      args += [
        features_folder,
        # __dir__ will return '/path_to_quke/quke/lib/quke' when run here. We
        # then take that result and replace `lib/quke` with `lib/features` to
        # get the value we need to pass to Cucumber
        "-r", __dir__.sub!("lib/quke", "lib/features"),
        "-r", features_folder
      ]
      args += additional_args.compact.map(&:strip)

      args
    end

    private

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def default_data!(data)
      data.merge(
        "features_folder" => (data["features"] || "features").downcase.strip,
        "app_host" => (data["app_host"] || "").downcase.strip,
        "driver" => (data["driver"] || "chrome").downcase.strip,
        "headless" => (data["headless"].to_s.downcase.strip == "true"),
        "print_progress" => (data["print_progress"].to_s.downcase.strip == "true"),
        "pause" => (data["pause"] || "0").to_s.downcase.strip.to_i,
        "stop_on_error" => (data["stop_on_error"] || "false").to_s.downcase.strip,
        "max_wait_time" => (data["max_wait_time"] || Capybara.default_max_wait_time).to_s.downcase.strip.to_i,
        "user_agent" => (data["user_agent"] || "").strip,
        # Because we want to default to 'true', but allow users to override it
        # with 'false' it causes us to mess with the logic. Essentially if the
        # user does enter false (either as a string or as a boolean) the result
        # will be 'true', so we flip it back to 'false' with !.
        # Else the condition fails and we get 'false', which when flipped gives
        # us 'true', which is what we want the default value to be
        # rubocop:disable Style/InverseMethods
        "display_failures" => !(data["display_failures"].to_s.downcase.strip == "false"),
        # rubocop:enable Style/InverseMethods
        "custom" => (data["custom"] || nil)
      )
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    def load_yml_data
      if File.exist? self.class.file_location
        # YAML.load_file returns false if the file exists but is empty. So
        # added the || {} to ensure we always return a hash from this method
        YAML.load_file(self.class.file_location) || {}
      else
        {}
      end
    end

  end

end
