# frozen_string_literal: true

module AppiumControls
  class PopupList
    def initialize(driver, root_sel, toggle_id)
      @driver = driver
      @root_selector = root_sel
      @toggle_id     = toggle_id
    end

    def cancel
      _cancel_button.click
    end

    def done
      _done_button.click
    end

    def options
      @driver.find_elements(class_chain: "#{@root_selector}/**/XCUIElementTypeTable/**/XCUIElementTypeStaticText").map(&:text)
    end

    def select(value)
      toggle unless open?
      _scroll_to(value) unless _option_visible?(value)
      @driver.find_element(class_chain: "#{@root_selector}/**/XCUIElementTypeTable/**/XCUIElementTypeStaticText[`name==\"#{value}\"`]").click
    end

    def toggle
      _toggle.click
    end

    def open?
      present = false
      @driver.set_implicit_wait(0.25)
      begin
        present = @driver.find_elements(class_chain: @root_selector).first&.displayed?
      rescue Selenium::WebDriver::Error::NoSuchElementError
        # Swallow this
      end
      @driver.set_implicit_wait(Nenv.element_wait_time)
      present
    end

    def displayed?
      present = false
      @driver.set_implicit_wait(0.25)
      begin
        present = _toggle&.displayed?
      rescue Selenium::WebDriver::Error::NoSuchElementError
        # Swallow this
      end
      @driver.set_implicit_wait(Nenv.element_wait_time)
      present
    end

    private

    def _toggle
      @toggle ||= @driver.find_elements(@toggle_id).first
    end

    def _scroll_to(value)
      @driver.scroll(direction: 'down', element: _table, name: value)
    end

    def _option_visible?(value)
      present = false
      @driver.set_implicit_wait(0.25)
      begin
        present = @driver.find_elements(class_chain: "#{@root_selector}/**/XCUIElementTypeTable/**/XCUIElementTypeStaticText[`name==\"#{value}\"`]").first&.displayed?
      rescue Selenium::WebDriver::Error::NoSuchElementError
        # Swallow this
      end
      @driver.set_implicit_wait(Nenv.element_wait_time)
      present
    end

    def _cancel_button
      @driver.find_element(class_chain: "#{@root_selector}/XCUIElementTypeNavigationBar/XCUIElementTypeButton")
    end

    def _done_button
      @driver.find_element(class_chain: "#{@root_selector}/XCUIElementTypeNavigationBar/XCUIElementTypeButton[2]")
    end

    def _table
      @table ||= @driver.find_elements(class_chain: "#{@root_selector}/**/XCUIElementTypeTable").first
    end
  end

  class DatePicker
    attr_reader :driver

    def initialize(driver, identifiers)
      @driver            = driver
      @picker_identifier = identifiers[:picker]
      @toggle_identifier = identifiers[:toggle]
      define_wheels
      define_setters
    end

    def toggle
      @toggle ||= @driver.find_elements(@toggle_identifier).first
      @toggle&.click
    end

    def value
      "#{self.month} #{self.day}, #{self.year}"
    end

    def value=(new_date)
      toggle
      d          = Chronic.parse(new_date)
      self.month = Date::MONTHNAMES[d.month]
      self.day   = d.day
      self.year  = d.year
      toggle
    rescue Exception => ex
      binding.pry
      STDOUT.puts ex.message
    end

    private

    def define_wheels
      %w[month day year].each_with_index do |what, idx|
        define_singleton_method("#{what}_wheel") do
          cached_element = instance_variable_get "@#{what}_element"
          return cached_element if cached_element
          element = driver.find_elements(@picker_identifier)[idx]
          instance_variable_set("@#{what}_element", element)
          element
        end

        define_singleton_method(what.to_s) do
          self.send("#{what}_wheel")&.value
        end
      end
    end

    def define_setters
      %w[month day year].each do |what|
        self.define_singleton_method("#{what}=") do |value|
          wheel = self.send("#{what}_wheel")
          until wheel.value == value.to_s
            delta     = self.send("delta_for_#{what}", wheel.value, value)
            direction = delta.positive? ? 'previous' : 'next'
            driver.select_picker_wheel element: wheel, order: direction, offset: [0.1 * delta.abs, 0.3].min
            STDOUT.puts wheel.value
          end
        end
      end
    end

    def direction_for_month(cur_value, new_value)
      new_month = new_value.is_a?(Integer) ? new_month : Chronic.parse(new_value).month

      begin
        Chronic.parse(cur_value).month < new_month ? 'next' : 'previous'
      rescue StandardError
        binding.pry; 2
      end
    end

    def direction_for_year(cur_value, new_value)
      cur_value.to_i < new_value.to_i ? 'next' : 'previous'
    end

    def direction_for_day(cur_value, new_value)
      cur_value.to_i < new_value.to_i ? 'next' : 'previous'
    end

    def delta_for_month(cur_value, new_value)
      new_month = new_value.is_a?(Integer) ? new_month : Chronic.parse(new_value).month
      Chronic.parse(cur_value).month - new_month
    end

    def delta_for_year(cur_value, new_value)
      cur_value.to_i - new_value.to_i
    end

    def delta_for_day(cur_value, new_value)
      cur_value.to_i - new_value.to_i
    end
  end
end
