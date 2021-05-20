# frozen_string_literal: true

require 'cpt_hook'
require 'page-object/accessors'
require 'lib/helpers/widget_register'

# Declare your custom element - This adds your tag to the Watir::Element Class as an individual element and a collection
Watir::Container.register_custom_element('one_app_nav_bar_item_root','one_app_nav_bar_item_roots','OneAppNavBarItemRoot','Element')

# We now need to add in the methods to find the element
# TODO:  See if we can add this to the widget register function

module PageObject
  module Platforms
    module Watir
      # Modify the PageObject class to add in calls to locate the new element or a collection of the new elements
      class PageObject
        def one_app_nav_bar_item_root_for(identifier)
          find_watir_element("one_app_nav_bar_item_root(identifier)", Elements::Element, identifier, 'one_app_nav_bar_item_root')
        end

        def one_app_nav_bar_item_roots_for(identifier)
          find_watir_elements("one_app_nav_bar_item_roots(identifier)", Elements::Element, identifier, 'one_app_nav_bar_item_roots')
        end
      end
    end
  end

  # Add Custom accessors if we need them.
  module Accessors
    #
    # adds a Salesforce specific control one-app-nav-bar-item-root to the page object
    # This control acts like a div but is declared as non-standard HTML tag <one-app-nav-bar-item-root/>
    #
    # @param [String] name This is the PO human name we declare, we use it to generate methods
    # @param [Hash] identifier how we identify the element.
    # @param [block] block optional block to be invoked when element method is called
    #   block examples include:
    #   hooks: WFA_HOOKS - pass in hooked element section, just WFA_HOOKS, which is wait_for_ajax after a set of actions
    # @author Joseph Ours
    #
    def one_app_nav_bar_item_root(name, identifier, &block)
      # This next line is required!  Otherwise, PageObject won't be able to find the _element calls
      standard_methods(name, identifier, 'one_app_nav_bar_item_root_for', &block)

      # Add support for HOOKS - TODO: Untested
      _hooked_methods = hooked_sm_em(name, identifier, 'one_app_nav_bar_item_root_for', "#{name}_po_element", &block)

      # this method makes calling the PO declared item the same as calling _element
      # Example, declare
      # one_app_nav_bar_item_root(:current_focused_tab, class: 'slds-is-active')
      # Then using
      # self.current_focused_tab is the same as self.current_focused_tab_element
      define_method(name) do
        self.send("#{name}_element")
      end
    end
  end
end
