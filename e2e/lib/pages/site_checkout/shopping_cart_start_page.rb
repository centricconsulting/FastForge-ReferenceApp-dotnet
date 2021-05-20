# frozen_string_literal: true
#/cart page

class ShoppingCartStartPage < MainPage
  checkbox(:tos_agree, id: 'termsofservice')
  button(:checkout_button, id: 'checkout')

  def open_cart
    # click past banner if present
    # puts self.notification.notification_message
    self.notification.close_notification if self.notification.present?
    wait_for_ajax
    self.store_header.shoppingcart_element.wait_until(&:present?)
    self.store_header.shoppingcart
    wait_for_ajax
  end

  def checkout
    self.check_tos_agree
    self.checkout_button
    wait_for_ajax
  end
end
