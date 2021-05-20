# frozen_string_literal: true

# This file contains definitions for common hooks used with
# the hookable accessors extension for Page Object
require 'cpt_hook'

# Ensure wait_for_ajax gets called for any function that
# could trigger ajax
WFA_HOOKS ||= CptHook.define_hooks do
  after(:click).call(:wait_for_ajax)
  after(:click!).call(:wait_for_ajax)
  after(:set).call(:wait_for_ajax)
  after(:value=).call(:wait_for_ajax)
  after(:check).call(:wait_for_ajax)
  after(:uncheck).call(:wait_for_ajax)
end

# Make sure the blue event fires after we set masked edits.
MASKED_EDIT_HOOKS ||= CptHook.define_hooks do
  after(:value=).call(:fire_event).with(:blur)
end

SEARCH_EDIT_HOOKS ||= CptHook.define_hooks do
  after(:value=).call(:send_keys).with(:tab)
end

BLUR_AND_WFA_AFTER ||= CptHook.define_hooks do
  after(:value=).call(:fire_event).with(:blur)
  after(:value=).call(:wait_for_ajax)
  after(:set).call(:fire_event).with(:blur)
  after(:set).call(:wait_for_ajax)
end

CLICK_BEFORE_SET ||= CptHook.define_hooks do
  before(:value=).call(:click)
  before(:set).call(:click)
end

GRID_EDIT_HOOKS ||= CptHook.define_hooks do
  before(:value=).call(:fire_event).with(:click)
  after(:value=).call(:send_keys).with(:escape)
end
