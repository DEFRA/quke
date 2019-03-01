# frozen_string_literal: true

require "quke/configuration"

module Quke #:nodoc:

  # Manages all parallel configuration for Quke.
  class ParallelConfiguration

    # Whether use of parallel tests has been enabled
    attr_reader :enabled
    # How to group the tests. Default is features
    attr_reader :group_by
    # How many processes to start. Default is 0 which means we will leave
    # ParallelTests to determine the number.
    attr_reader :processes

    def initialize(config)
      @config = config
      data = @config.data["parallel"] || {}
      @enabled = (data["enable"].to_s.downcase.strip == "true")
      @group_by = (data["group_by"] || "default").downcase.strip
      @processes = (data["processes"] || "0").to_s.downcase.strip.to_i
    end

    # Returns an array of arguments, correctly ordered for passing to
    # +ParallelTests::CLI.new.run()+.
    #
    # The arguments are based on the values set for the parallel configuration
    # plus those passed in. It then orders them in an order that makes sense to
    # parallel tests.
    def command_args(additional_args = [])
      args = standard_args(@config.features_folder)
      args += ["--single", "--quiet"] unless @enabled
      args += ["--group-by", @group_by] unless @group_by == "default"
      args += ["-n", @processes.to_s] if @enabled && @processes.positive?
      args + ["--test-options", @config.cucumber_arg(additional_args)]
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

  end

end
