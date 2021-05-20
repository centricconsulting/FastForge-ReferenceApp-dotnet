# frozen_string_literal: true

# This contains the various MagicPaths used by the suite.
#
# MagicPaths allows us to cleanly declare paths that are dynamic.
# A path is declared using a patten that consists of text and tokens
# when a path is resolved the tokens are replaced with their values
# from either the environment or from a hash passed to the resolver.
#
# The defaults here are rather simple, they allow for generic fixture files
# and environment specific files.  Using these values fixture files are loaded
# from the folder specified by the FIXTURE_ROOT enviroment variables.
#
# Normal fixture files are are just a basename and extension i.e. foo.yml
# Environment fixture files use the TEST_ENV enviroment variable and
# look like foo.preprod.yml.  Assuming TEST_ENV == 'preprod'.
#
# Using this system we can easily load data customized data based on
# environment variables.
#
# For example, if we had multiple brands that required special data
# we could set fixture_file_base to ':filename:brand:ext' and load
# 'foo.branda.yml' when we ask to load 'foo' and the environment variable
# BRAND is set to 'branda'.
#
# But maybe only SOME files are brand specific but we want to fall back
# to a basic file name if we don't have a brand specific version.
# In that case we would create a new path called :fixture_file_band
# set up like the above.  Then we'd add it to the FIXTURE_FILE_PATTERNS
# constant.
#
require 'magic_path'

# Since Cucumber can load things multiple times, guard this from executing.
unless MagicPath.instance.respond_to?(:fixture_path)
  # This determines the search order for loading fixture files
  # if you add another pattern for filenames, add it to the array below.
  # The first fixture file found is the one loaded.
  FIXTURE_FILE_PATTERNS = %i[fixture_file_env fixture_file_base]

  # The default path for just uses the environment var FIXTURE_ROOT
  MagicPath.create_path :fixture_path, pattern: ':fixture_root'

  # This is used to determine the actual filename for a fixture file
  MagicPath.create_path :fixture_file_base, pattern: ':filename:ext'

  # This determines the filename for environment specific fixture files.
  MagicPath.create_path :fixture_file_env, pattern: ':filename.:test_env:ext'
end
