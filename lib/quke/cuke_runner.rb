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
      @args = [
        Quke.config.features_folder,
        # Because cucumber is called in the context of the executing script it
        # will take the next argument from that position, not from where the gem
        # currently sits. This means to Cucumber 'lib/features' doesn't exist,
        # which means our env.rb never gets loaded. Instead we first have to
        # determine where this file is running from when called, then we simply
        # replace the last part of that result (which we know will be lib/quke)
        # with lib/features. We then pass this full path to Cucumber so it can
        # correctly find the folder holding our predefined env.rb file.
        "-r", __dir__.sub!("lib/quke", "lib/features"),
        "-r", Quke.config.features_folder
      ] + passed_in_args
    end

    # Executes Cucumber passing in the arguments array, which was set when the
    # instance of CukeRunner was initialized.
    # rubocop:disable Lint/HandleExceptions
    def run
      Cucumber::Cli::Main.new(@args).execute!
    rescue SystemExit
      # Cucumber calls @kernel.exit() killing your script unless you rescue
      # If any tests fail cucumber will exit with an error code however this
      # is expected and normal behaviour. We capture the exit to prevent it
      # bubbling up to our app and closing it.
    end
    # rubocop:enable Lint/HandleExceptions

  end

end
