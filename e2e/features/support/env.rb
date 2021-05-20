# frozen_string_literal: true

# Add the project root to the lib path so we can easily include lib files.
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../..")

require 'rubygems'
require 'bundler/setup'
require_relative 'nenv_vars'
require_relative 'paths'
require 'lib/framework_support'

binding.pry if Nenv.cuke_debug
# raise 'TEST_ENV is not set' if ENV['TEST_ENV'].nil?

# Configure native mobile
if Nenv.native_mobile?
  MobileHelper.initialize_appium
  begin
    World(AppiumNav)
      # rubocop:disable Lint/RescueException
  rescue Exception
    STDOUT.puts 'Warning failed to add AppiumNav to the world.  This is only OK if in the console!'
  end
  # rubocop:enable Lint/RescueException
end

# Set up the world
begin
  World(PageObject::PageFactory)
  World(DataMagic)
  World(Centric)
# rubocop:disable Lint/RescueException
rescue Exception
  STDOUT.puts 'Warning failed to initialize the world.  This is only OK if in the console!'
end
# rubocop:enable Lint/RescueException

PageObject::JavascriptFrameworkFacade.add_framework(:extjs, ::PageObject::Javascript::ExtJS)
PageObject::JavascriptFrameworkFacade.framework = :extjs
PageObject.default_element_wait = 15
