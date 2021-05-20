# frozen_string_literal: true

require 'watir'
require 'page-object'

# Extending Watir module
module Watir
  # Extending Container module
  module Container

    def self.register_custom_element(element_tag, element_pluralized, element_class, inherit_from_element = Element)
      # Defines the element in Watir as a method
      define_method(element_tag.to_sym) { |*args| eval(element_class).new(self, extract_selector(args).merge(tag_name: element_tag.gsub('_', '-'))) }

      # Defines a collection of elements in Watir as a method
      define_method(element_pluralized) { |*args| eval("#{element_class}Collection").new(self, extract_selector(args).merge(tag_name: element_tag.gsub('_', '-'))) }

      # Instantiate the classes for a single element and the collection of elements
      Container.const_set(element_class, Class.new(Element))
      Container.const_set("#{element_class}Collection", Class.new(ElementCollection) do
        define_method('element_class') { eval(element_class) }
      end)

      # Interacting with the element
      Object.const_set(element_class, Class.new(eval("PageObject::Elements::#{inherit_from_element}")))

      # Registering the class with the PageObject gem.
      # register_widget accepts a tag which is used as the accessor (ex: mh_button), the class which is added to
      # the Elements module (ex: MHButton), and a html element tag which is used as the html element (ex: mh_button).
      PageObject.register_widget element_tag.to_sym, eval(element_class), element_tag.to_sym

    end
  end
end
