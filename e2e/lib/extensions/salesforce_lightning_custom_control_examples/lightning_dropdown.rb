# frozen_string_literal: true

require 'cpt_hook'
require 'page-object/accessors'
module PageObject
  # This class creates methods and accessors to properly interact with a salesforce
  # dropdown list.  A dropdown list is a text box under the covers.  But you have to click into it
  # then the system then provides a popup panel of viable options. You must select from
  # that list to properly set the value.  You can't just set the value of the text field alone.
  # This covers the list of items that appears
  class SFBoundListFloating < SimpleDelegator
    def initialize(element, item_selector)
      super(element)
      @item_selector = item_selector
    end

    def items
      item_elements.map(&:text)
    end

    def select_item(str_or_regex)
      item = item_elements.detect { |i| str_or_regex.is_a?(Regexp) ? str_or_regex.match(i.text) : i.text == str_or_regex }
      raise "Could not locate a list item matching '#{str_or_regex}'. Check capitalization of values. Here is what I found: #{items}" unless item

      item.click
    end

    def item_elements
      elements(@item_selector).first.wait_until(&:present?)
      elements(@item_selector)
    end
  end

  # This class creates methods and accessors to properly interact with a salesforce
  # dropdown list.  A dropdown list is a text box under the covers.  But you have to click into it
  # then the system then provides a popup panel of viable options. You must select from
  # that list to properly set the value.  You can't just set the value of the text field alone.
  # This covers the list open/close action
  class SFDropdown < SimpleDelegator
    def initialize(element, list_selector, item_selector)
      super(element)
      @item_selector = item_selector
      @list_selector = list_selector
    end

    def open?
      list_element.exists? && list_element.visible?
    end

    def open
      click unless open?
    end

    def close
      click if open?
    end

    def closed?
      !open?
    end

    def list
      open
      @list ||= SFBoundListFloating.new(list_element, @item_selector)
    end

    def select_item(str_or_regex)
      list.select_item str_or_regex
    end

    alias set select_item

    def value
      text
    end

    def list_element
      div(@list_selector)
    end
  end

  # These are the associated accessors for the salesforce dropdown control
  module Accessors
    #
    # adds a SF Lightning specific dropdown list to the page object
    # This control acts like a text box, but after entering teh value, you have to select
    # from the provided list.  e.g Zip Codes.
    # @example
    #   sf_dropdown(:account_industry, id: 'industry')
    #   def set_account_industry(value)
    #     account_industry = value
    #   end
    #
    #   or
    #
    #   account_industry = 'Manufacturing'
    #   Action: = will click into the element
    #   Then, will select the retrieved list of items that popup as a result
    #   and select an item to confirm based input value OR Regex to select item
    #
    # @param [String] name used for the generated methods
    # @param [Hash] identifier how we identify the underlying text field.
    # @param [block] block optional block to be invoked when element method is called
    #   block examples include:
    #   list_sel: [Hash] { identifier_hash } - identifiers to identify the list container.  Has a default of
    #     { xpath: "//div[contains(@class,'x-boundlist-floating')]", visible: true }
    #   item_sel: { identifier_hash } - identifiers to identify each list item in the container.  Has a default { class: 'x-boundlist-item' }.
    #   hooks: WFA_HOOKS - pass in hooked element section, just WFA_HOOKS, which is wait_for_ajax after a set of actions
    # @author Joseph Ours
    #
    def sf_dropdown(name, identifier = { index: 0 }, &block)
      list_sel = identifier.delete(:list) || { xpath: "//div[contains(@class,'select-options') and contains(@class, 'uiMenuList ')]", visible: true } # list_sel = identifier.delete(:list) || {xpath: "//div[not(contains(@style,'display:none')) and contains(@class,'x-boundlist-floating')]"}
      item_sel = identifier.delete(:items) || { class: 'uiMenuItem' }
      _hooked_methods = hooked_sm_em(name, identifier, 'text_field_for', "#{name}_po_element", &block)

      define_method("#{name}_element") do
        begin
          return SFDropdown.new(send("#{name}_po_element"), list_sel, item_sel)
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          retry
        end
      end

      define_method(name) do
        send("#{name}_element").text
      end

      define_method("#{name}=") do |value|
        send("#{name}_element").select_item(value)
      end

      # add empty method so I can detect if this element is of this type vs a similar standard type
      # Only the custom type will respond to this
      define_method("#{name}_is_sf_dropdown") do
      end
    end
  end
end
