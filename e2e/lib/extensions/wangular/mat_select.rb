# frozen_string_literal: true

module Watir
  # Represents a mat-select-option element
  class MatSelectOption < HTMLElement
    alias element_text text
    def initialize(query_scope, selector)
      super
      @text_cache = element_text
    end

    # @return [String] the text of the option.
    def text
      @text_cache
    end

    # @return [Boolean] True if the option is selected
    def selected?
      class_name.include? 'mat-selected'
    end

    # Selects the item
    def select
      attempts = 0
      begin
        click
      rescue Selenium::WebDriver::Error::UnknownError
        attempts += 1
        retry unless attempts > 5
      end
    end
  end

  # Represents a mat-select element
  class MatSelect < HTMLElement
    def initialize(query_scope, selector)
      super
      @options = nil
    end

    # @param [Boolean] relocate Pass true to bust the options cache and find them again
    # @return [Array] an array of MatSelectOption
    def options(relocate = false)
      find_option_elements if @options.nil? || relocate
      @options
    end

    # @param [Boolean] relocate Pass true to bust the options cache and find them again
    # @return [Array] an array of strings with the text of the options
    def options_text(relocate = false)
      options(relocate).map(&:text)
    end

    # @return [MatSelectOption, Nil] the selected option or nil
    def selected_option
      opt = nil
      with_opened_list { opt = options.find(&:selected?) }
      opt
    end

    # @return [String] the text of the option.
    def value
      text
    end

    # Selects an option from the list
    # @param [String, Regexp] str_or_rx
    # @return [String] The text of the selected option
    def value=(str_or_rx)
      select str_or_rx
    end

    # Selects an option from the list
    # @param [String, Regexp] str_or_rx
    # @return [String] The text of the selected option
    def select(str_or_rx)
      opt = nil
      with_opened_list do
        opt = options.find { |o| o.text == str_or_rx } if str_or_rx.is_a?(String)
        opt = options.find { |o| str_or_rx.match(o.text) } if str_or_rx.is_a?(Regexp)
        opt.select
      end
      opt.text
    end

    # @param [String, Regexp] str_or_rx
    # @return [bool] True if the string or regex is in the list of options
    def include?(str_or_rx)
      opt = options.find { |o| o.text == str_or_rx } if str_or_rx.is_a?(String)
      opt = options.find { |o| str_or_rx.match(o.text) } if str_or_rx.is_a?(Regexp)
      !opt.nil?
    end

    # Closes the dropdown list if it's open
    # @return [nil]
    def close
      return unless open?
      selected_option.click
    end

    # @return [bool] True if the list is open
    def open?
      !attribute_value('aria-owns').nil?
    end

    # Open the dropdown for this select.
    #
    # @return [bool] Returns true if the list was already open
    def open
      return true if open?
      click
      false
    end

    protected

    def owned_element_ids
      attribute_value('aria-owns').to_s.split
    end

    def with_opened_list
      was_open = open
      yield
      close unless was_open
    end

    def find_option_elements
      with_opened_list do
        @options = owned_element_ids.map { |id| MatSelectOption.new(self, xpath: "//*[@id=\"#{id}\"]") }
      end
    end
  end
  class MatSelectCollection < ElementCollection
  end

  module Container
    # @return [Button]
    def mat_select(*args)
      MatSelect.new(self, extract_selector(args).merge(tag_name: 'mat-select'))
    end

    # # @return [ButtonCollection]
    def mat_selects(*args)
      MatSelectCollection.new(self, extract_selector(args).merge(tag_name: 'mat-select'))
    end

    Watir.tag_to_class[:mat_select] = MatSelect
  end
end
