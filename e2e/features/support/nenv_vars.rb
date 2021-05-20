# frozen_string_literal: true

# This file defines the various environment variables used by the suite.
#
# We define Nenv methods for many environment variables where we want to
# provide a default value if the env var is missing.
#
# See the documentation for details on the various env vars that can be
# used to tune the framework.
#
require 'nenv'
require 'lib/helpers/config'

# Namespace for all helpers
module Helpers
  # Cucumber doesn't require files it loads them... multiple times
  # We only want to do this once so we'll just see if Nenv responds to our method already
  unless Nenv.respond_to? :test_env
    # Framework Nenv vars that do NOT have defaults set
    # Nenv.move_browser true/false
    # Nenv.size_browser true/false

    # These constants represent defaults for, or in some cases keys for, the Nenv methods below
    ENV_KEY          = 'TEST_ENV' # What environment variable holds our runtime environment?
    DEFAULT_TEST_ENV = 'test' # What should the default TEST_ENV be?
    DEFAULT_RECORD_VIDEO = false # Record video of test run

    DEFAULT_CONFIG_PATH = './config' # Where should Helpers::Config load it's yml data

    DEFAULT_BROWSER_TYPE         = :local # What should the default BROWSER_TYPE be?
    DEFAULT_BROWSER_BRAND        = :chrome # What should the default BROWSER_BRAND be? [need yml file in ./config as same browser name]
    DEFAULT_BROWSER_RESOLUTION   = '1920x1080' # What should the default BROWSER_RESOLUTION be '1920x1080'?
    DEFAULT_SAUCE_CLIENT_TIMEOUT = 180 # What should the default SAUCE_CLIENT_TIMEOUT be?

    DEFAULT_SELENIUM_HUB_HOST = 'localhost' # What should the default host be for Selenium hub
    DEFAULT_SELENIUM_HUB_PORT = 4444 # What should the default port be for Selenium hub

    DEFAULT_SERVER_HOST = 'localhost'
    DEFAULT_SERVER_PORT = 8080

    DEFAULT_FIXTURE_ROOT = './fixtures' # Default folder for fixture files
    DEFAULT_SCREENSHOT_PATH = './screenshots' # where to save screenshots
    DEFAULT_JSON_REPORT_PATH = './reports' # where to save output
    DEFAULT_VIDEO_PATH = './videos' # where to save screenshots

    FAIL_FAST = false # quit cucumber quickly on fails, aborts some processing
    CUKE_ENV_DEBUG = false # manually debug cukes
    CUKE_STEP_SIZE = 0 # manually debug cuke step size, must be greater than 1 to execute

    # Stuff that changes based on the runtime environment for the app
    Nenv.instance.create_method(:test_env) { Nenv.send(ENV_KEY) || DEFAULT_TEST_ENV }
    Nenv.instance.create_method(:server_hostname) { |v| v.nil? ? Config.instance[:environments][Nenv.test_env.to_sym][:server_hostname] : v }
    Nenv.instance.create_method(:server_port) { |v| v.nil? ? Config.instance[:environments][Nenv.test_env.to_sym][:server_port] : v }
    Nenv.instance.create_method(:base_url) { |v| v.nil? ? "http://#{Nenv.server_hostname}:#{Nenv.server_port}/cc" : v }

    # Stuff that tunes the framework
    Nenv.instance.create_method(:config_path) { |v| v.nil? ? DEFAULT_CONFIG_PATH : v.tr('\\', '/') }
    Nenv.instance.create_method(:fixture_root) { |v| v.nil? ? DEFAULT_FIXTURE_ROOT : v.tr('\\', '/') }
    Nenv.instance.create_method(:cuke_debug) { |v| v.nil? ? CUKE_ENV_DEBUG : v.to_sym }
    Nenv.instance.create_method(:fail_fast) { |v| v.nil? ? FAIL_FAST : v.to_sym }
    Nenv.instance.create_method(:screenshot_path) { |v| v.nil? ? DEFAULT_SCREENSHOT_PATH : v.tr('\\', '/') }
    Nenv.instance.create_method(:json_report_path) { |v| v.nil? ? DEFAULT_JSON_REPORT_PATH : v.tr('\\', '/') }
    Nenv.instance.create_method(:cuke_step_size) { |v| v.nil? ? CUKE_STEP_SIZE : v }
    Nenv.instance.create_method(:record_video?) { |v| v.nil? ? DEFAULT_RECORD_VIDEO : v.to_sym }
    Nenv.instance.create_method(:video_path) { |v| v.nil? ? DEFAULT_VIDEO_PATH : v.tr('\\', '/') }

    # Stuff for creating browsers
    Nenv.instance.create_method(:browser_type) { |v| v.nil? ? DEFAULT_BROWSER_TYPE : v.to_sym }
    Nenv.instance.create_method(:browser_brand) { |v| v.nil? ? DEFAULT_BROWSER_BRAND : v.to_sym }
    Nenv.instance.create_method(:browser_resolution) { |v| v.nil? ? DEFAULT_BROWSER_RESOLUTION : v }
    Nenv.instance.create_method(:browser_width) { Nenv.browser_resolution.split('x').first.to_i }
    Nenv.instance.create_method(:browser_height) { Nenv.browser_resolution.split('x').last.to_i }
    Nenv.instance.create_method(:browser_x, &:to_i)
    Nenv.instance.create_method(:browser_y, &:to_i)

    # Sauce labs config
    Nenv.instance.create_method(:sauce_url) { |v| v.nil? ? Config.instance[:sauce_labs][:url] : v }
    Nenv.instance.create_method(:sauce_platform) { |v| v.to_s.tr('_', ' ') }
    Nenv.instance.create_method(:sauce_client_timeout) { |v| v.nil? ? DEFAULT_SAUCE_CLIENT_TIMEOUT : v.to_i }

    # Selenium hub config
    Nenv.instance.create_method(:selenium_hub_host) { |v| v.nil? ? DEFAULT_SELENIUM_HUB_HOST : v }
    Nenv.instance.create_method(:selenium_hub_port) { |v| v.nil? ? DEFAULT_SELENIUM_HUB_PORT : v.to_i }
    Nenv.instance.create_method(:selenium_hub_url) { |v| v.nil? ? "http://#{Nenv.selenium_hub_host}:#{Nenv.selenium_hub_port}/wd/hub" : v }
  end
end
