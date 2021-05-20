#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../features/support/env'

include PageObject::PageFactory
include DataMagic
# FixtureHelper.load_fixture 'guidewire_test.yml'

@browser = Helpers::Browser.create_browser
visit(LoginPage).login_as('su', 'gw')

page = on(ClaimCenterPage)
# page.north_panel.link_menu_open?
# page.north_panel.logout_link_element.text
page.north_panel.ensure_link_menu_open
# page.north_panel.ll_test
state = page.north_panel.link_menu_toggle_closed?
page.north_panel.link_menu.logout_link_element.exists?

# rubocop:disable Lint/Debugger
binding.pry
puts 'Line for pry'
# rubocop:enable Lint/Debugger
