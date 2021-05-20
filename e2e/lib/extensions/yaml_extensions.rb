# frozen_string_literal: true

require 'erb'
require 'yaml'
## YAML namespace for monkey patching
module YAML
  ##
  # :category: extensions
  #
  # Allows for including other yaml files inside of yaml files.  All paths are relative to the yaml file passed into load_erb
  def self.include(file_name)
    full_path = "#{@root}/#{file_name}"
    env_path = "#{full_path}.#{ENV['TEST_ENV']}"
    full_path = env_path if File.exist?(env_path)
    ERB.new(IO.read(full_path)).result
  end

  ##
  # :category: extensions
  #
  # Load a yaml file using ERB so that we can use the include command.
  def self.load_erb(file_name)
    @root = File.dirname(file_name)
    YAML.load(YAML.include(File.basename(file_name)))
  end
end
