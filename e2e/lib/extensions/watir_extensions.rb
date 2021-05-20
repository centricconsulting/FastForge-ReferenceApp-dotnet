# frozen_string_literal: true

module Watir
  #
  # Base class for HTML elements.
  #

  class Element

    # Scrolls item into view and then clicks it.  If effort fails, likely due to a
    # header, we scroll by another 100px and try again
    #
    # :category: extensions
    # @author Joseph Ours
    def scroll_and_click
      self.wd.location_once_scrolled_into_view
      self.send(:click)
    rescue Selenium::WebDriver::Error::UnknownError => e
      puts 'Element not initially clickable'
      if e.message.include? 'Element is not clickable'
        self.driver.execute_script('window.scrollBy(0,-100);')
        self.send(:click)
      end
    end

    # Performs an element locate and returns the element
    #
    # @return [Element] returns the located element
    # :category: extensions
    #
    # @author Donovan Stanley
    def relocate
      @element = locate
      self
    end
  end
end
