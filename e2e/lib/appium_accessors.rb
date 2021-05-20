# frozen_string_literal: true
require 'chronic'
require_relative 'appium_controls'

# rubocop:disable Metrics/ModuleLength
module AppiumAccessors
  include AppiumControls

  def modal(name, screen_class)
    define_method(name) do |use_cache = true|
      cached_screen = instance_variable_get "@#{name}_screen"
      return cached_screen if cached_screen && use_cache
      screen = screen_class.new(driver)
      instance_variable_set("@#{name}_screen", screen)
      screen
    end
  end
  alias section modal

  def date_picker(name, identifiers)
    scroll_data = identifiers.delete(:scroll)
    element_scrolling_methods(name, scroll_data)
    define_method("#{name}_element") do |use_cache = true|
      control = instance_variable_get "@#{name}_picker"
      return control if control && use_cache
      control = DatePicker.new(driver, identifiers)
      instance_variable_set("@#{name}_picker", control)
      control
    end

    define_method(name) do
      self.send("#{name}_element").value
    end

    define_method("#{name}=") do |value|
      self.send("#{name}_element").value = value
    end
  end

  def popup_table(name, title, identifiers)
    scroll_data = identifiers.delete(:scroll)
    element_scrolling_methods(name, scroll_data)
    presence_check(name)

    define_method("#{name}_element") do |_use_cache = true|
      root_sel = "**/XCUIElementTypeOther[$type==\"XCUIElementTypeNavigationBar\" and name==\"#{title}\"$]"
      PopupList.new(driver, root_sel, identifiers[:toggle])
    end

    define_method("#{name}=") do |value|
      self.send("#{name}_element").select value
    end

    define_method("#{name}") do
      driver.find_element(identifiers[:value]).text
    end
  end

  def popup_table_wo_header(name, root_selector, identifiers)
    scroll_data = identifiers.delete(:scroll)
    element_scrolling_methods(name, scroll_data)
    presence_check(name)

    define_method("#{name}_element") do |_use_cache = true|
      PopupList.new(driver, root_selector, identifiers[:toggle])
    end

    define_method("#{name}=") do |value|
      self.send("#{name}_element").select value
    end

    define_method("#{name}") do
      driver.find_element(identifiers[:value]).text
    end
  end

  def text_field(name, identifier, index = nil)
    if identifier.is_a?(Hash)
      find_with_find_element(name, identifier, index)
    else
      find_with_built_in_finders(name, identifier, 'textfield', index)
    end
    standard_methods(name, :value)

    define_method("#{name}=") do |value|
      ele = self.send("#{name}_element")
      ele.clear
      ele.type value
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  def switch(name, identifier, index = nil)
    find_with_find_element(name, identifier, index)
    standard_methods(name)

    define_method(name) do
      self.send("#{name}_element").text == 'on'
    end

    define_method("check_#{name}") do
      e = self.send("#{name}_element")
      e.click unless e.value == '1'
    end

    define_method("uncheck_#{name}") do
      e = self.send("#{name}_element")
      e.click unless e.value == '0'
    end

    define_method("#{name}=") do |value|
      normalized_val = value if value.is_a?(String)
      normalized_val = value ? '1' : '0' unless value.is_a?(String)
      e = self.send("#{name}_element")
      e.click unless e.value == normalized_val
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength

  def nav_bar(name, identifier, index = nil)
    find_with_find_element(name, identifier, index)
    standard_methods(name, :text)
  end

  def table(name, identifier, index = nil)
    find_with_find_element(name, identifier, index)
    standard_methods(name)

    define_method("swipe_#{name}") do |direction|
      driver.execute_script('mobile:swipe', element: self.send("#{name}_element").ref, direction: direction.to_s)
    end

    define_method("scroll_#{name}_to") do  |direction = 'down'|
      driver.execute_script('mobile: scroll', { "element": self.send("#{name}_element"), "predicateString": value,  'direction': direction.to_s })
    end
  end

  def activity_indicator(name, identifier, index = nil)
    find_with_find_element(name, identifier, index)
    standard_methods(name)
  end

  def other(name, identifier, index = nil)
    find_with_find_element(name, identifier, index)
    standard_methods(name, :text)
  end

  def image(name, identifier, index = nil)
    find_with_find_element(name, identifier, index)
    standard_methods(name, :click)
  end

  def static_text(name, identifier, index = nil)
    find_with_find_element(name, identifier, index)
    standard_methods(name, :text)
  end

  def static_text_button(name, identifier, index = nil)
    find_with_find_element(name, identifier, index)
    standard_methods(name, :click)
  end

  def button(name, identifier, index = nil)
    if identifier.is_a?(Hash)
      find_with_find_element(name, identifier, index)
    else
      find_with_built_in_finders(name, identifier, 'button', index)
    end
    standard_methods(name, :click)
  end

  def presence_check(name)
    define_method("#{name}?") do
      present = false
      driver.set_implicit_wait(0.25)
      begin
        present = self.send("#{name}_element")&.displayed?
      rescue Selenium::WebDriver::Error::NoSuchElementError
        # Swallow this
      end
      driver.set_implicit_wait(Nenv.element_wait_time)
      present == true
    end

    define_method("#{name}_exist?") do
      present = false
      driver.set_implicit_wait(0.25)
      begin
        present = !self.send("#{name}_element", false).nil?
      rescue Selenium::WebDriver::Error::NoSuchElementError
        # Swallow this
      end
      driver.set_implicit_wait(Nenv.element_wait_time)
      present == true
    end
  end

  def standard_methods(name, default_method = nil)
    unless default_method.nil?
      define_method(name) do
        self.send("#{name}_element").send(default_method)
      end
    end

    define_method("click_#{name}") do
      self.send("#{name}_element").click
    end

    define_method("#{name}_text") do
      self.send("#{name}_element").text
    end

    presence_check(name)
  end

  def element_scrolling_methods(name, scroll_data)
    return unless scroll_data
    value = scroll_data.is_a?(Hash) ? scroll_data[:value] : scroll_data
    define_method("scroll_to_#{name}") do  |direction = 'down'|
      container = self.send(scroll_data.fetch(:container, :root_element))
      driver.execute_script('mobile: scroll', {"element": container, "predicateString": value,  'direction': direction.to_s })
    end

    define_method("scroll_to_#{name}_if_needed") do |direction = 'down'|
      self.send("scroll_to_#{name}", direction) unless self.send("#{name}?")
    end
  end

  def find_with_built_in_finders(name, identifier, method, index = nil)
    if identifier.is_a?(Hash)
      scroll_data = identifier.delete(:scroll)
      element_scrolling_methods(name, scroll_data)
    end

    define_method("#{name}_element") do |_use_cache = true|
      # cached_element = instance_variable_get "@#{name}_element"
      # return cached_element if cached_element && use_cache
      element = driver.send(method, identifier.clone) if index.nil?
      element = driver.send("#{method}s", identifier.clone)[index] unless index.nil?
      raise Selenium::WebDriver::Error::NoSuchElementError unless element
      # instance_variable_set("@#{name}_element", element)
      element
    end
  end

  def find_with_find_element(name, identifier, index = nil)
    scroll_data = identifier.delete(:scroll)
    element_scrolling_methods(name, scroll_data)
    how, what = identifier.shift
    define_method("#{name}_element") do |_use_cache = false|
      # cached_element = instance_variable_get "@#{name}_element"
      # return cached_element if cached_element && use_cache
      element = driver.find_elements(how, what).first unless index
      element = driver.find_elements(how, what)[index] if index
      raise Selenium::WebDriver::Error::NoSuchElementError unless element
      # instance_variable_set("@#{name}_element", element)
      element
    end

    define_method("click_#{name}") do
      self.send("#{name}_element").click
    end
    define_method("#{name}_text") do
      self.send("#{name}_element").text
    end
  end
end
# rubocop:enable Metrics/ModuleLength
