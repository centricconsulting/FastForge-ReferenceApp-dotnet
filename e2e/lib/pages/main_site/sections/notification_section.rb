# frozen_string_literal: true

class NotificationSection < BasePage

  # fields
  span(:close, class: 'close')
  p(:message, class: 'content')

  def close_notification
    self.close_element.click if self.close_element.present?
  end

  def notification_message
    self.message_element.text if self.message_element.present?
  end
end
