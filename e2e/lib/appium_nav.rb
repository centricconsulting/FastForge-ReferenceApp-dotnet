# frozen_string_literal: true

# Provides a set of functions for navigation similar to those used by PageObject
module AppiumNav
  # Singleton class for caching pages so we don't have to find them again
  class ScreenCache
    include Singleton
    def screen_cache
      @screen_cache ||= {}
    end

    def new_or_existing_screen(screen_class)
      screen_cache[screen_class.to_s] = screen_class.new unless screen_cache.key?(screen_class.to_s)
      screen_cache[screen_class.to_s]
    end
  end

  # Equivalent to on_page in PageObject, sets @current_page
  #
  # Examples:
  #   on_screen('LoginScreen') # Uses default_app_for_nav for the app
  #   on_screen('LoginScreen', 'WorkCenter Marketing') # Passing the app name sets default_app_for_nav
  #   on_screen('WorkCenterMarketing::LoginScreen') # Gets namespaced to 'Screens::PLATFORM::WorkCenterMarketing::LoginScreen'
  #   on_screen(Screens::IOS::WorkCenterMarketing::LoginScreen) # Explicit screen class
  #
  # @param screen [Constant, String, Symbol] The screen class.  Names will be camelcased automatically
  # @param app_name [String, Symbol] The name of the app, used for namespacing. Will be camelcased automatically
  def on_screen(screen, app_name = nil)
    @default_app_for_nav = app_name unless app_name.nil?
    screen_const = defined?(screen) == 'constant' ? screen : to_screen_class(screen, app_name)
    screen_obj = ScreenCache.instance.new_or_existing_screen(screen_const)
    @current_screen = screen_obj
    yield screen_obj if block_given?
    screen_obj
    end

  # Sets the default app name to use for namespacing screen constants
  def default_app_for_nav=(app_name)
    @default_app_for_nav = app_name
  end

  # yields the current page
  def on_current_screen
    yield @current_screen if block_given?
    @current_screen
  end

  def to_screen_class(screen, app_name = nil)
    app_name ||= @default_app_for_nav
    platform = Nenv.mobile_platform == 'iOS' ? 'IOS' : 'Android'
    const_name = app_name.nil? ? "Screens::#{platform}::#{screen}" : "Screens::#{platform}::#{app_name.tr(' ', '')}::#{screen.to_s.camelcase(:upper)}"
    Object.const_get(const_name)
  end
end
