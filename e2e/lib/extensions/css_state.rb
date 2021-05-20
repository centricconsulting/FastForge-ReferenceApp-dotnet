# frozen_string_literal: true

require 'page-object/accessors'
module PageObject
  #
  # Contains the class level methods that are inserted into your page objects
  # when you include the PageObject module.  These methods will generate another
  # set of methods that provide access to the elements on the web pages.
  #
  module Accessors
    # Internal helper function to keep css_state small.
    # This will create
    def _define_default_state(name, states, default_state)
      return if states.key?(default_state)
      define_method("#{name}_#{default_state}?") do
        ele = send("#{name}_element")
        states.none? { |_k, v| ele.css_class_match?(v) }
      end
    end

    def _define_state_fns(name, states)
      states.each do |k, v|
        define_method("#{name}_#{k}?") do
          send("#{name}_element").css_class_match?(v)
        end
      end
    end

    # Define a state engine for an existing element based on CSS classes
    #
    # The css_state method accepts another element as it's first argument
    # and then a hash containing state names and the CSS classes that represent
    # those states.  For example:
    #
    # link(:show_contacts, data_bind: /ShowContacts/)
    # css_state(:show_contacts, open: 'k-minus', closed: 'k-plus')
    #
    # Here we've defined a link called "show_contacts".
    # We've all defined two states "open" and "closed" and the CSS classes
    # associated with those states.
    #
    # With that in place we can query the state of that element with "ELEMENT_STATE?"
    # where ELEMENT is the element name and STATE is one of the states we've defined.
    # For example:
    #
    # page.show_contacts_open?
    #
    # Quite often you'll encounter elements that only have a CSS class for one
    # of their states.  In those cases you can define an additional state as the
    # absence of a class.  For example:
    #
    #
    # li(:contacts_menu_dropdown, xpath: '//*[@id="sp-navbar"]/ul/li[1]')
    # css_state(:contacts_menu_dropdown, open: 'open', closed: { not: 'open' })
    #
    # When the dropdown is open the CSS class "open" is applied.
    # When it's closed the "open" CSS class is removed, but no "closed" class appears.
    # By passing a hash with the keyword "not" we can pass a class name that should
    # be missing in order for the element to be in this state.
    #
    # @param name [Symbol] The existing element you want to create states for.
    # @param states [Hash] The states and their classes as documented above
    def css_state(name, states)
      default_state = states.delete(:default) || :unknown
      _define_state_fns(name, states)
      _define_default_state(name, states, default_state)

      define_method("#{name}_state") do
        ele = send("#{name}_element")
        (key, _value) = states.find { |_k, v| ele.css_class_match?(v) }
        key ||= default_state
        key
      end
    end
  end
end

module Watir
  class Element
    # Flexible way to ask if an element has, or does not have a CSS class.
    #
    # It can be called with a simple string:
    #   element.css_class_match?('foo')
    #     # Returns true if any of the CSS classes are exactly named foo
    #
    # It can be called with a regex:
    #
    #   element.css_class_match?(/foo/)
    #   # Returns true if any of the CSS classes contain the 'foo' i.e. foo_bar, foobar, myfoo
    #
    # The invert parameter inverts the meaning so:
    #
    #   element.css_class_match?('foo', true)
    #   # Returns true if NONE of the CSS classes are exactly named foo
    #
    #
    # The matcher can be a hash in the form of:
    #  { has: 'some_class' } or { not: 'some_class'}
    #
    # This is primarily used by the css_state method
    #
    # @param matcher [String, Regex, Hash] See examples
    # @param invert [Boolean] Returns true if the class does NOT exist.
    def css_class_match?(matcher, invert = false)
      return css_class_match?(matcher.values.first, matcher.keys.first == :not) if matcher.is_a?(Hash)
      method = matcher.is_a?(Regexp) ? :match? : :include?
      val = class_name.send(method, matcher)
      invert ? !val : val
    end
  end
end
