# frozen_string_literal: true

module Watir
  class MatRadioButton < Input
    def initialize(query_scope, selector)
      super
    end

    #
    # Selects this radio button.
    #

    def set
      click unless set?
    end
    alias select set

    #
    # Is this radio set?
    #
    # @return [Boolean]
    #

    def set?
      class_name.include? 'mat-radio-checked'
    end
    alias selected? set?

    #
    # Returns the text of the associated label.
    # Returns empty string if no label is found.
    #
    # @return [String]
    #

    def text
      div(class: 'mat-radio-label-content').text
    end
  end

  module Container
    def mat_radio(*args)
      MatRadioButton.new(self, extract_selector(args).merge(tag_name: 'mat-radio-button'))
    end

    def radios(*args)
      MatRadioCollection.new(self, extract_selector(args).merge(tag_name: 'mat-radio-button'))
    end

    Watir.tag_to_class[:mat_radio_button] = MatRadioButton
  end

  class MatRadioCollection < InputCollection
    private

    def element_class
      MatRadioButtonRadio
    end
  end
end
