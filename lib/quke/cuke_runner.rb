# frozen_string_literal: true

require "cucumber"
require "parallel_tests"

module Quke #:nodoc:

  # Handles executing Cucumber, including sorting the arguments we pass to it
  class CukeRunner

    # Access the arguments used by Quke when it was executed
    attr_reader :args

    # When an instance of CukeRunner is initialized it will take the arguments
    # passed in and combine them with its own default args. Those args are a mix
    # of ones specific to ParallelTests, and ones for Cucumber.
    #
    # In essence we are getting ParallelTests to pass the following to Cucumber
    # along with whatever args are passed in when Quke is called.
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
    #       set this to be sure to handle tagged scenarios, or features run in
    #       parallel.
    def initialize(passed_in_args = [])
      Quke.config = Configuration.new
      @args = parallel_args + test_options_args(passed_in_args)
    end

    # Executes ParallelTests, which in turn executes Cucumber passing in the
    # arguments defined when the instance of CukeRunner was initialized.
    def run
      ParallelTests::CLI.new.run(@args)
    rescue SystemExit => e
      # Cucumber calls @kernel.exit() killing your script unless you rescue
      raise StandardError, "Cucumber exited in a failed state" unless e.success?
    end

    private

    def parallel_args
      args = [
        Quke.config.features_folder,
        "--type", "cucumber",
        "--serialize-stdout",
        "--combine-stderr"
      ]
      args += ["--single", "--quiet"] unless Quke.config.parallel
      args
    end

    def test_options_args(passed_in_args)
      # Because cucumber is called in the context of the executing project and
      # not Quke it will take its arguments in the context of that location, and
      # not from where the Quke currently sits. This means to Cucumber
      # 'lib/features' doesn't exist, which means our env.rb never gets loaded.
      # Instead we first have to determine where this file is running from when
      # called, then we simply replace the last part of that result (which we
      # know will be lib/quke) with lib/features. For example __dir__ returns
      # '/Users/acruikshanks/projects/defra/quke/lib/quke' but we need Cucumber
      # to load '/Users/acruikshanks/projects/defra/quke/lib/features'
      # We then pass this full path to Cucumber so it can correctly find the
      # folder holding our predefined env.rb file.
      env_folder = __dir__.sub!("lib/quke", "lib/features")
      [
        "--test-options",
        "--format pretty -r #{env_folder} -r #{Quke.config.features_folder} #{passed_in_args.join(' ')}"
      ]
    end

  end

end
