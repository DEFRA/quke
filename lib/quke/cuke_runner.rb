require 'cucumber'

module Quke #:nodoc:

  # Handles executing Cucumber, including sorting the arguments we pass to it
  class CukeRunner

    attr_reader :args

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
    #       use Browserstack, or switch between running against Chrom or firefox
    #       locally
    #   - +-r my_features_folder+, if you specify a different folder for
    #       or wish to test just specific features, you are required by Cucumber
    #       to also require the folder which contains your steps
    # features directory contains the +env.rb+
    def initialize(features_folder, args = [])
      @args = [
        features_folder,
        '-r', 'lib/features',
        '-r', features_folder
      ] + args
    end

    # Executes Cucumber, passing in the arguments hash set when the instance of
    # CukeRunner was created.
    def run
      Cucumber::Cli::Main.new(@args).execute!
    rescue SystemExit => e
      # Cucumber calls @kernel.exit() killing your script unless you rescue
      raise StandardError, 'Cucumber exited in a failed state' unless e.success?
    end

  end

end
