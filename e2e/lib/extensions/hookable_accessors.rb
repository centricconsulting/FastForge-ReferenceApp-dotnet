# frozen_string_literal: true

require 'cpt_hook'
require 'page-object/accessors'

# Rubocop has problems with metaprogramming.
module PageObject
  module Platforms
    module Watir
      #
      # Watir implementation of the page object platform driver.  You should not use the
      # class directly.  Instead you should include the PageObject module in your page object
      # and use the methods dynamically added from the PageObject::Accessors module.
      #
      class PageObject
        def root_from_identifier(root_id)
          return @browser if root_id.nil?
          new_root = send(root_id) if root_id.is_a?(Symbol) && respond_to?(root_id)
          new_root ||= @browser.send(root_id) if root_id.is_a?(Symbol)

          new_root
        end

        def process_watir_call(the_call, type, identifier, value = nil, tag_name = nil)
          root_object                   = root_from_identifier identifier.delete(:root)
          identifier, frame_identifiers = parse_identifiers(identifier, type, tag_name)
          value                         = root_object.instance_eval "#{nested_frames(frame_identifiers)}#{the_call}"
          switch_to_default_content(frame_identifiers)
          value
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
    def text_field_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'text_field_for', &block)
      define_method(name) do
        return platform.text_field_value_for identifier.clone unless block_given? || hooked_methods.include?(:value)
        send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        return platform.text_field_value_set(identifier.clone, value) unless block_given? || hooked_methods.include?(:value=)
        send("#{name}_element").value = value
      end
    end

    def text_area_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'text_area_for', &block)
      define_method(name) do
        return platform.text_area_value_for identifier.clone unless block_given? || hooked_methods.include?(:value)
        send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        return platform.text_area_value_set(identifier.clone, value) unless block_given? || hooked_methods.include?(:value=)
        send("#{name}_element").value = value
      end
    end

    alias textarea_hooked text_area_hooked

    def select_list_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'select_list_for', &block)
      define_method(name) do
        return platform.select_list_value_for identifier.clone unless block_given? || hooked_methods.include?(:value)
        send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        return platform.select_list_value_set(identifier.clone, value) unless block_given? || hooked_methods.include?(:select)
        send("#{name}_element").select(value)
      end
      define_method("#{name}_options") do
        element = send("#{name}_element")
        element&.options ? element.options.collect(&:text) : []
      end
    end

    alias select_hooked select_list_hooked

    def link_hooked(name, identifier = { index: 0 }, &block)
      _hooked_methods = hooked_standard_methods(name, identifier, 'link_for', &block)
      define_method(name) do
        #return platform.click_link_for identifier.clone unless block_given? || hooked_methods.include?(:click)
        ele = send("#{name}_element")
        ele.focus
        ele.click!
      end
    end

    alias a_hooked link_hooked

    def checkbox_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'checkbox_for', &block)
      define_method("check_#{name}") do
        return platform.check_checkbox(identifier.clone) unless block_given? || hooked_methods.include?(:check)
        send("#{name}_element").check
      end
      define_method("uncheck_#{name}") do
        return platform.uncheck_checkbox(identifier.clone) unless block_given? || hooked_methods.include?(:uncheck)
        send("#{name}_element").uncheck
      end
      define_method("#{name}_checked?") do
        return platform.checkbox_checked?(identifier.clone) unless block_given? || hooked_methods.include?(:checked?)
        send("#{name}_element").checked?
      end
    end

    def radio_button_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'radio_button_for', &block)
      define_method("select_#{name}") do
        return platform.select_radio(identifier.clone) unless block_given? || hooked_methods.include?(:select)
        send("#{name}_element").select
      end
      define_method("#{name}_selected?") do
        return platform.radio_selected?(identifier.clone) unless block_given? || hooked_methods.include?(:selected?)
        send("#{name}_element").selected?
      end
    end

    alias radio_hooked radio_button_hooked

    def button_hooked(name, identifier = { index: 0 }, &block)
      _hooked_methods = hooked_standard_methods(name, identifier, 'button_for', &block)
      define_method(name) do
        #return platform.click_button_for identifier.clone unless block_given? || hooked_methods.include?(:click)
        ele = send("#{name}_element")
        ele.focus
        ele.click!
      end
    end

    def div_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'div_for', &block)
      define_method(name) do
        return platform.div_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def span_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'span_for', &block)
      define_method(name) do
        return platform.span_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def table_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'table_for', &block)
      define_method(name) do
        return platform.table_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def cell_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'cell_for', &block)
      define_method(name.to_s) do
        return platform.cell_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    alias td_hooked cell_hooked

    def row_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'row_for', &block)
      define_method(name.to_s) do
        return platform.row_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def image_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'image_for', &block)
      define_method("#{name}_loaded?") do
        return platform.image_loaded_for identifier.clone unless block_given? || hooked_methods.include?(:loaded?)
        send("#{name}_element").loaded?
      end
    end

    alias img_hooked image_hooked

    def form_hooked(name, identifier = { index: 0 }, &block)
      hooked_standard_methods(name, identifier, 'form_for', &block)
    end

    def list_item_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'list_item_for', &block)
      define_method(name) do
        return platform.list_item_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    alias li_hooked list_item_hooked

    def unordered_list_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'unordered_list_for', &block)
      define_method(name) do
        return platform.unordered_list_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    alias ul_hooked unordered_list_hooked

    def ordered_list_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'ordered_list_for', &block)
      define_method(name) do
        return platform.ordered_list_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    alias ol_hooked ordered_list_hooked

    def h1_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'h1_for', &block)
      define_method(name) do
        return platform.h1_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def h2_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'h2_for', &block)
      define_method(name) do
        return platform.h2_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def h3_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'h3_for', &block)
      define_method(name) do
        return platform.h3_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def h4_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'h4_for', &block)
      define_method(name) do
        return platform.h4_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def h5_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'h5_for', &block)
      define_method(name) do
        return platform.h5_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def h6_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'h6_for', &block)
      define_method(name) do
        return platform.h6_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def paragraph_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'paragraph_for', &block)
      define_method(name) do
        return platform.paragraph_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    alias p_hooked paragraph_hooked

    def file_field_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'file_field_for', &block)
      define_method("#{name}=") do |value|
        return platform.file_field_value_set(identifier.clone, value) unless block_given? || hooked_methods.include?(:value)
        send("#{name}_element").value = value
      end
    end

    def label_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'label_for', &block)
      define_method(name) do
        return platform.label_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def area_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'area_for', &block)
      define_method(name) do
        return platform.click_area_for identifier.clone unless block_given? || hooked_methods.include?(:click)
        send("#{name}_element").click
      end
    end

    def canvas_hooked(name, identifier = { index: 0 }, &block)
      hooked_standard_methods(name, identifier, 'canvas_for', &block)
    end

    def audio_hooked(name, identifier = { index: 0 }, &block)
      hooked_standard_methods(name, identifier, 'audio_for', &block)
    end

    def video_hooked(name, identifier = { index: 0 }, &block)
      hooked_standard_methods(name, identifier, 'video_for', &block)
    end

    def b_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'b_for', &block)
      define_method(name) do
        return platform.b_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    def i_hooked(name, identifier = { index: 0 }, &block)
      hooked_methods = hooked_standard_methods(name, identifier, 'i_for', &block)
      define_method(name) do
        return platform.i_text_for identifier.clone unless block_given? || hooked_methods.include?(:text)
        send("#{name}_element").text
      end
    end

    alias icon_hooked i_hooked

    # This is a variant of standard_methods, it sets up the wrapper for elements that have hooks
    # it ensures that whenever we ask for "#{name}_element" our wrappers will apply the various _hooked
    # DSL functions ensure that "#{name}_element" is always used regardless of block status

    def _add_common_hook_methods
      return if respond_to?(:resolve_with)
      define_method(:resolve_with) do |with_var|
        return self if with_var == :page
        return :self if with_var == :element
        return parent_page if with_var == :parent_page
        with_var
      end

      define_method(:hook_cache) do
        @hook_cache ||= {}
      end

      define_method(:cached_hooks) do |hook_defs, ele_name|
        hd = hook_defs.dup
        hd.hooks.each { |hook| hook.call_chain.each { |cc| cc.resolve_with { |c| resolve_with(c) } } }
        hd.hooks.each { |hook| hook.call_chain.each { |cc| cc.resolve_contexts { |c| resolve_with(c) } } }
        CptHook::Hookable.new(nil, hd, self)
      end
    end

    def hooked_sm_em(name, identifier, method, element_method, &block)
      hooks = identifier.delete(:hooks)
      unless hooks
        define_method(element_method) do
          return call_block(&block) if block_given?
          platform.send(method, identifier.clone)
        end
        define_method("#{name}?") do
          return call_block(&block).exists? if block_given?
          platform.send(method, identifier.clone).exists?
        end
        return [] # This ensures that our return value is safe for checking hooks regardless
      end

      _add_common_hook_methods

      define_method(element_method) do
        wrapper = cached_hooks(hooks, name)
        return wrapper.__setobj__(call_block(&block)) if block_given?
        wrapper.__setobj__(platform.send(method, identifier.clone))
        wrapper
      end

      define_method("#{name}_unhooked") do
        return call_block(&block) if block_given?
        platform.send(method, identifier.clone)
      end

      define_method("#{name}?") do
        wrapper = cached_hooks(hooks, name)
        return call_block(&block).exists? if block_given?
        wrapper.__setobj__(platform.send(method, identifier.clone)).exists?
      end

      hooks&.hooked_methods || []
    end

    def hooked_standard_methods(name, identifier, method, &block)
      hooks = identifier.delete(:hooks)
      unless hooks
        standard_methods(name, identifier, method, &block)
        return [] # This ensures that our return value is safe for checking hooks regardless
      end

      _add_common_hook_methods

      define_method("#{name}_element") do
        wrapper = cached_hooks(hooks, name)
        return wrapper.__setobj__(call_block(&block)) if block_given?
        wrapper.__setobj__(platform.send(method, identifier.clone))
        wrapper
      end

      define_method("#{name}_unhooked") do
        return call_block(&block) if block_given?
        platform.send(method, identifier.clone)
      end

      define_method("#{name}?") do
        wrapper = cached_hooks(hooks, name)
        return call_block(&block).exists? if block_given?
        wrapper.__setobj__(platform.send(method, identifier.clone)).exists?
      end

      hooks&.hooked_methods || []
    end

    def define_hooks(&block)
      CptHook.define_hooks(&block)
    end
  end
end
# rubocop:enable,
# rubocop:enable
