# frozen_string_literal: true

module Watir
  class MatSlideToggle < Input
    #
    # Sets slide toggle to the given value.
    #
    # @example
    #   checkbox = browser.mat_slide_toggle(id: 'new_user_interests_cars')
    #   checkbox.set?        #=> false
    #   checkbox.set
    #   checkbox.set?        #=> true
    #   checkbox.set(false)
    #   checkbox.set?        #=> false
    #
    # @param [Boolean] bool
    #
    def set(bool = true)
      click unless bool == set?
    end
    alias check set

    #
    # Returns true if the element is checked
    # @return [Boolean]
    #
    def set?
      class_name.include? 'mat-checked'
    end
    alias checked? set?

    #
    # Unsets checkbox.
    #

    def clear
      set false
    end
    alias uncheck clear
  end

  module Container
    def mat_slide_toggle(*args)
      MatSlideToggle.new(self, extract_selector(args).merge(tag_name: 'mat-slide-toggle'))
    end

    def mat_slide_toggles(*args)
      MatSlideToggleCollection.new(self, extract_selector(args).merge(tag_name: 'mat-slide-toggle'))
    end

    Watir.tag_to_class[:mat_slide_toggle] = MatSlideToggle
  end

  class MatSlideToggleCollection < InputCollection
  end
end
