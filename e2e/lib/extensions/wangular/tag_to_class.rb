# frozen_string_literal: true

module Watir
  class << self
    def open_tag_to_class
      @tag_to_class = tag_to_class.dup
    end

    def element_class_for(tag_name)
      tag_to_class[tag_name.to_s.tr('-', '_').to_sym] || HTMLElement
    end
  end
end
