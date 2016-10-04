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
    File.expand_path('data', File.dirname(__FILE__))
  end
end
