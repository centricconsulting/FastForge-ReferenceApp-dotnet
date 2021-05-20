# frozen_string_literal: true

module PageObject
  module Elements

    # Internal wrapper for mat_select elements
    class MatSelect < Element
    end

    ::PageObject::Elements.type_to_class[:mat_select] = ::PageObject::Elements::MatSelect

    class MatRadioButton < Element
    end

    ::PageObject::Elements.type_to_class[:mat_radio] = ::PageObject::Elements::MatRadioButton

    class MatSlideToggle < Element
    end

    ::PageObject::Elements.type_to_class[:mat_slide_toggle] = ::PageObject::Elements::MatSlideToggle

    class CoveredCheckbox < Element
    end

    ::PageObject::Elements.type_to_class[:covered_checkbox] = ::PageObject::Elements::CoveredCheckbox
  end

  module Platforms
    module Watir
      #
      # Watir implementation of the page object platform driver.  You should not use the
      # class directly.  Instead you should include the PageObject module in your page object
      # and use the methods dynamically added from the PageObject::Accessors module.
      #
      class PageObject
        #
        # platform method to retrieve a mat-select element
        # See PageObject::Accessors#mat_select
        #
        def mat_select_for(identifier)
          find_watir_element('mat_select(identifier)', Elements::MatSelect, identifier)
        end

        #
        # platform method to retrieve a mat-radio element
        # See PageObject::Accessors#mat_radio
        #
        def mat_radio_for(identifier)
          find_watir_element('mat_radio(identifier)', Elements::MatRadioButton, identifier)
        end

        #
        # platform method to retrieve a mat-slide-toggle element
        # See PageObject::Accessors#mat_slide_toggle
        #
        def mat_slide_toggle_for(identifier)
          find_watir_element('mat_slide_toggle(identifier)', Elements::MatSlideToggle, identifier)
        end

        #
        # platform method to retrieve a covered checkbox element
        # See PageObject::Accessors#mat_slide_toggle
        #
        def covered_checkbox_for(identifier)
          find_watir_element('covered_checkbox(identifier)', Elements::CoveredCheckbox, identifier)
        end
      end
    end
  end

  module Accessors
    # Accessor for mat_select element
    # These work like regular select_lists
    def mat_select_hooked(name, identifier, &block)
      hooked_standard_methods(name, identifier, 'mat_select_for', &block)

      define_method(name) do
        send("#{name}_element").text
      end
      define_method("#{name}=") do |value|
        send("#{name}_element").select(value)
      end

      define_method("#{name}_options") do
        element = send("#{name}_element")
        element&.options ? element.options.collect(&:text) : []
      end
    end
    alias mat_select mat_select_hooked

    # Accessor for mat_radio_buttons elements
    # These work like normal radio buttons
    def mat_radio_button_hooked(name, identifier = { index: 0 }, &block)
      hooked_standard_methods(name, identifier, 'mat_radio_for', &block)
      define_method("select_#{name}") do
        send("#{name}_element").select
      end
      define_method("#{name}_selected?") do
        send("#{name}_element").selected?
      end
    end

    alias mat_radio_hooked mat_radio_button_hooked
    alias mat_radio mat_radio_button_hooked
    alias mat_radio_button mat_radio_button_hooked

    # Accessor for mat_slide_toggle elements
    # These work just like checkboxes
    def mat_slide_toggle_hooked(name, identifier = { index: 0 }, &block)
      hooked_standard_methods(name, identifier, 'mat_slide_toggle_for', &block)
      define_method("check_#{name}") do
        send("#{name}_element").check
      end
      define_method("uncheck_#{name}") do
        send("#{name}_element").uncheck
      end
      define_method("#{name}_checked?") do
        send("#{name}_element").checked?
      end
    end
    alias mat_slide_toggle mat_slide_toggle_hooked

    # Accessor for checkboxes that have a label covering them
    def covered_checkbox_hooked(name, identifier = { index: 0 }, &block)
      hooked_standard_methods(name, identifier, 'covered_checkbox_for', &block)
      define_method("check_#{name}") do
        send("#{name}_element").check
      end
      define_method("uncheck_#{name}") do
        send("#{name}_element").uncheck
      end
      define_method("#{name}_checked?") do
        send("#{name}_element").checked?
      end
    end

    alias covered_checkbox covered_checkbox_hooked
  end
end
