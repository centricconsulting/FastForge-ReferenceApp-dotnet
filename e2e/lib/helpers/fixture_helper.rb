# frozen_string_literal: true

# Root module for helpers.
module Helpers
  ## Helper module for loading, merging and saving fixture files
  # Uses the Yaml include monkey patch.
  module Fixtures
    # Default folder for fixture files
    DEFAULT_FIXTURE_FOLDER ||= Nenv.fixture_root

    # Given a scenario, load any fixture it needs.
    # Fixture tags should be in the form of @fixture_FIXTUREFILE
    def self.load_fixtures_for(scenario, fixture_folder = DEFAULT_FIXTURE_FOLDER)
      DataMagic.yml_directory = fixture_folder
      fixture_files = fixture_files_on(scenario)
      warn "Found #{fixture_files.count} fixtures on scenario.  Using #{fixture_files.last}." if fixture_files.count > 1
      DataMagic.load "#{fixture_files.last}.yml" if fixture_files.count.positive?
    end

    # Load a fixture file by name, returns a hash of the data
    def self.load_fixture(name, fixture_folder = DEFAULT_FIXTURE_FOLDER)
      DataMagic.yml_directory = fixture_folder
      DataMagic.load "#{name}.yml"
    end

    # Given a hash save it as a fixture
    def self.save_fixture(name, data, fixture_folder = DEFAULT_FIXTURE_FOLDER)
      File.open("#{fixture_folder}/#{name}.yml", 'w') { |yf| YAML.dump(data, yf) }
    end

    # Load a fixture and merge it with an existing hash
    def self.load_fixture_and_merge_with(fixture_name, base_hash, fixture_folder = DEFAULT_FIXTURE_FOLDER)
      new_hash = load_fixture(fixture_name, fixture_folder)
      base_hash.deep_merge new_hash
    end

    # @return [Array] Returns all the tags on a scenario that match our fixture pattern
    def self.fixture_tags_on(scenario)
      # tags for cuke 2, source_tags for cuke 1
      tags = scenario.send(scenario.respond_to?(:tags) ? :tags : :source_tags)
      tags.map(&:name).select { |t| t =~ /@fixture_/ }
    end

    # @return [Array] Returns all potential fixture filenames on a scenario
    def self.fixture_files_on(scenario)
      fixture_tags_on(scenario).map { |t| t.gsub('@fixture_', '').to_sym }
    end
  end
end
