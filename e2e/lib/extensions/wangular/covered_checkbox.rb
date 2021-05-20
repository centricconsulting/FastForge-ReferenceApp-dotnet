# frozen_string_literal: true

module Watir
  class CoveredCheckbox < CheckBox
    #
    # Sets checkbox to the given value.
    #
    # @example
    #   checkbox = browser.covered_checkbox(id: 'new_user_interests_cars')
    #   checkbox.set?        #=> false
    #   checkbox.set
    #   checkbox.set?        #=> true
    #   checkbox.set(false)
    #   checkbox.set?        #=> false
    #
    # @param [Boolean] bool
    #

    def set(bool = true)
      click! unless bool == set?
    end
    alias check set
  end

  module Container
    def covered_checkbox(*args)
      CoveredCheckbox.new(self, extract_selector(args).merge(tag_name: 'input', type: 'checkbox'))
    end

    def covered_checkboxes(*args)
      CoveredCheckboxCollection.new(self, extract_selector(args).merge(tag_name: 'input', type: 'checkbox'))
    end
  end

  class CoveredCheckboxCollection < InputCollection
  end
end
