# frozen_string_literal: true

# rubocop:disable Lint/UselessAssignment,
# rubo cop:disable Metrics/ModuleLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

module PageObject
  #
  # Construct a new page object.  Prior to browser initialization it will call
  # a method named initialize_accessors if it exists. Upon initialization of
  # the page it will call a method named initialize_page if it exists.
  #
  # @param root [Watir::Browser, Watir::HTMLElement, Selenium::WebDriver::Driver, Selenium::WebDriver::Element] the platform browser/element to use
  # @param visit [bool] open the page if page_url is set
  # @param parent [PageObject] - The parent Page
  def initialize(root, visit = false, parent = nil)
    @parent_page = parent
    initialize_accessors if respond_to?(:initialize_accessors)
    initialize_browser(root)
    goto if visit && self.class.instance_methods(false).include?(:goto)
    initialize_page if respond_to?(:initialize_page)
  end
  attr_reader :parent_page

  def parent_browser
    parent_page&.browser
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
        # platform method to return a PageObject rooted at an element
        # See PageObject::Accessors#page_section
        #
        def page_for(identifier, page_class, parent)
          find_watir_page(identifier, page_class, parent)
        end

        attr_reader :parent_page

        def initialize(browser, parent = nil)
          @browser = browser
          @parent_page = parent
        end

        #
        # platform method to return a collection of PageObjects rooted at elements
        # See PageObject::Accessors#page_sections
        #
        def pages_for(identifier, page_class, parent)
          SectionCollection[*find_watir_pages(identifier, page_class, parent)]
        end

        def find_watir_pages(identifier, page_class, parent = nil)
          parent_element = identifier.delete(:parent_element) || @browser
          identifier, frame_identifiers = parse_identifiers(identifier, Elements::Element, 'element')
          elements = parent_element.instance_eval "#{nested_frames(frame_identifiers)}elements(identifier)"
          switch_to_default_content(frame_identifiers)
          elements.map { |element| page_class.new(element, false, parent) }
        end

        def find_watir_page(identifier, page_class, parent = nil)
          parent_element = identifier.delete(:parent_element) || @browser
          identifier, frame_identifiers = parse_identifiers(identifier, Elements::Element, 'element')
          element = parent_element.instance_eval "#{nested_frames(frame_identifiers)}element(identifier)"
          switch_to_default_content(frame_identifiers)
          page_class.new(element, false, parent)
        end
      end
    end
  end

  #
  # Contains the class level methods that are inserted into your page objects
  # when you include the PageObject module.  These methods will generate another
  # set of methods that provide access to the elements on the web pages.
  #
  module Accessors
    #
    # adds a method to return a page object rooted at an element
    # this differs from the standard page_section in that passes
    # a parent to the section.
    #
    # @example
    #   page_section(:navigation_bar, NavigationBar, :id => 'nav-bar')
    #   # will generate 'navigation_bar'
    #
    # @param name [Symbol] the name used for the generated methods
    # @param section_class [Class] the class to instantiate for the element
    # @param identifier [Hash] identifier how we find an element.
    #
    def page_section(name, section_class, identifier)
      define_method(name) do
        platform.page_for(identifier, section_class, self)
      end

      define_method("#{name}_element") do
        platform.element_for(:element, identifier.clone)
      end
      define_method("#{name}?") do
        send("#{name}_element").present?
      end
    end

    #
    # adds a method to return a collection of page objects rooted at elements
    #
    # @example
    #   page_sections(:articles, Article, :class => 'article')
    #   # will generate 'articles'
    #
    # @param [Symbol] the name used for the generated method
    # @param [Class] the class to instantiate for each element
    # @param [Hash] identifier how we find an element.
    #
    def page_sections(name, section_class, identifier, parent = self)
      define_method(name) do
        platform.pages_for(identifier, section_class, parent)
      end
    end

    def external_page_section(name, section_class, parent_element, identifier)
      define_method(name) do
        identifier[:parent_element] = send(parent_element) if parent_element.is_a?(Symbol)
        identifier[:parent_element] = parent_element.call if parent_element.is_a?(Proc)
        platform.page_for(identifier, section_class, self)
      end
    end
  end
end
# rubocop:enable Lint/UselessAssignment,
# ru bocop:enable Metrics/ModuleLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
