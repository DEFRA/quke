# frozen_string_literal: true

module Quke #:nodoc:

  # Manages all parallel configuration for Quke.
  class ParallelConfiguration

    attr_reader :enabled, :group_by, :processes

    def initialize(data = {})
      @enabled = (data["enable"].to_s.downcase.strip == "true")
      @group_by = (data["group_by"] || "default").downcase.strip
      @processes = (data["processes"] || "0").to_s.downcase.strip.to_i
    end

    def command_args(features_folder, additional_args = [])
      args = standard_args(features_folder)
      args += ["--single", "--quiet"] unless @enabled
      args += ["--group-by", @group_by] unless @group_by == "default"
      args += ["-n", @processes.to_s] if @enabled && @processes.positive?
      args + test_options_args(features_folder, additional_args)
    end

    private

    def standard_args(features_folder)
      [
        features_folder,
        "--type", "cucumber",
        "--serialize-stdout",
        "--combine-stderr"
      ]
    end

    def test_options_args(features_folder, additional_args)
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
        "--format pretty -r #{env_folder} -r #{features_folder} #{additional_args.join(' ')}".strip
      ]
    end

  end

end
