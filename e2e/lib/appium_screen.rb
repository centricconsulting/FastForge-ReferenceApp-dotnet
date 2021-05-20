# frozen_string_literal: true

require_relative 'appium_accessors'
require_relative 'appium_nav'
module ScreenObject
  attr_reader :driver
  include DataMagic
  def initialize(driver = nil)
    # rubocop:disable Style/GlobalVars
    @driver = driver || $driver
    # rubocop:enable Style/GlobalVars
  end

  # @private
  def self.included(cls)
    cls.extend AppiumAccessors
  end

  def populate_with(data)
    data.each do  |k, v|
      next unless self.respond_to?("#{k}=")
      driver.hide_keyboard
      self.send("scroll_to_#{k}_if_needed") if self.respond_to?("scroll_to_#{k}_if_needed") && !self.send("#{k}?")
      self.send("#{k}=", v)
    end
  end

  def populate(data = {})
    populate_with cache_data_for(self.class.to_s.split(':').last.snakecase).merge(data)
  end

  def swipe(direction)
    driver.execute_script('mobile:swipe', element: self.send('root_element').ref, direction: direction)
  end

  def try_find_element(identifier)
    ele = nil
    driver.set_implicit_wait(0.5)
    begin
      ele = driver.find_element(identifier)
    # rubocop:disable Lint/HandleExceptions
    rescue Selenium::WebDriver::Error::NoSuchElementError
      # Swallow this
    end
    # rubocop:enable Lint/HandleExceptions
    driver.set_implicit_wait(Nenv.element_wait_time)
    ele
  end
end
