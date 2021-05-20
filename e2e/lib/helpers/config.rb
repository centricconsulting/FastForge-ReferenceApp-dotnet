# frozen_string_literal: true

require 'yaml'
require 'singleton'

# Helper modules should all live in the helper namespace.
module Helpers
  # A singleton class for loading configuration information for the suite.
  # It's implemented as a singleton and available via Config.instance
  # YAML files contained in CONFIG_PATH will be loaded into the config class using
  # the basename of the file as the key.
  # i.e. ./config/environments.yml will be available as Config.instance[:environments]
  #
  class Config
    include Singleton
    attr_accessor :data
    extend Forwardable
    def_delegator :@data, :[]

    # Load the files in Nenv.config_path
    def initialize
      @data = {}
      Dir.glob(File.join(Nenv.config_path, '*.yml')) do |yml_file|
        @data[File.basename(yml_file, '.yml').to_sym] = YAML.load(File.read(yml_file))
      end
    end
  end
end
