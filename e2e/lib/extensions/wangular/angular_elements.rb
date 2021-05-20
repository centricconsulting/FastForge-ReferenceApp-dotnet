# frozen_string_literal: true

require_relative 'tag_to_class'

Watir.open_tag_to_class

require_relative 'mat_select'
require_relative 'mat_radio_button'
require_relative 'mat_slide_toggle'
require_relative 'covered_checkbox'

Watir.open_tag_to_class.freeze
