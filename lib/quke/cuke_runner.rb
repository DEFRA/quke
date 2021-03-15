# frozen_string_literal: true

require "cucumber"

module Quke #:nodoc:

  # Handles executing Cucumber, including sorting the arguments we pass to it
  class CukeRunner

    # When an instance of CukeRunner is initialized it will take the arguments
    # passed in and combine them with its own default args.
    #
    # The default args add the following to the parameters passed to Cucumber
    #
    #     [my_features_folder, '-r', 'lib/features', '-r', my_features_folder]
    #
    # Its these args that pass our features directory to cucumber along with
    # the user's. So to break it down
    #   - +my_features_folder+, first arg tells Cucumber where the feature files
    #       are located
    #   - +-r 'lib/features'+, tells Cucumber to require our features folder.
    #       This is how we get it to use our +env.rb+ which handles all the
    #       setup on behalf of the user (the point of Quke) to do things like
    #       use Browserstack, or switch between running against Chrome or
    #       firefox locally
    #   - +-r my_features_folder+, if you specify a different folder for
    #       or wish to test just specific features, you are required by Cucumber
    #       to also require the folder which contains your steps. So we always
    #       set this to be sure to handle tagged scenarios
    def initialize(passed_in_args = [])
      Quke.config = Configuration.new
      @args = Quke.config.cucumber_args(passed_in_args)
    end

    # Executes Cucumber passing in the arguments array, which was set when the
    # instance of CukeRunner was initialized.
    def run
      Cucumber::Cli::Main.new(@args).execute!
    rescue SystemExit
      # Cucumber calls @kernel.exit() killing your script unless you rescue
      # If any tests fail cucumber will exit with an error code however this
      # is expected and normal behaviour. We capture the exit to prevent it
      # bubbling up to our app and closing it.
      # Abort sets error code to 1 otherwise status code 0 returned at end of test run
      # hiding failing tests run in CI
      abort "Failing tests"
    end

  end

end
