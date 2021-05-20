# frozen_string_literal: true

require_relative 'main_site/sections/store_header'
require_relative 'main_site/sections/notification_section'

class MainPage < BasePage
  page_section(:store_header, StoreHeader, class: 'header')
  page_section(:notification, NotificationSection, id: 'bar-notification')

end
