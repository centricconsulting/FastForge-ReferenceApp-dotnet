# frozen_string_literal: true

# This widget allows us to treat a span as a button instead of a source for text
# If you NEED the text use the NAME_text method.
class SpanButton < PageObject::Elements::Span
  def self.accessor_methods(accessor, name)
    accessor.send(:define_method, name) do
      send("#{name}_element").click
    end

    accessor.send(:define_method, "#{name}_text") do
      return platform.span_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
      send("#{name}_element").text
    end
  end
end
PageObject.register_widget :span_button, SpanButton, :span
