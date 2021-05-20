# frozen_string_literal: true
# /onepagecheckout

require_relative 'sections/checkout_page_sections'

class CheckoutPage < MainPage
  page_section(:billing, BillingSection, id:'opc-billing')
  page_section(:shipping, ShippingSection, id:'opc-shipping')
  page_section(:shipping_method, ShippingMethodSection, id:'opc-shipping_method')
  page_section(:payment_method, PaymentMethodSection, id:'opc-payment_method')
  page_section(:payment_info, PaymentInfoSection, id:'opc-payment_info')
  page_section(:confirm_order, ConfirmOrderSection, id:'opc-confirm_order')

  def default_data
    { checkout: 'test' }
  end

  def populate_billing(data = {})
    self.billing.populate(data)
    self.billing.continue
    wait_for_ajax
  end

  def populate_shipping(data = {})
    self.shipping.populate(data)
    self.shipping.continue
    wait_for_ajax
  end

  def populate_shipping_method(data = {})
    ship_method = data.is_a?(Hash) ? data["shipping_method"] : data
    self.shipping_method.ship_method_select(ship_method)
    self.shipping_method.continue
    wait_for_ajax
  end

  def populate_credit_card(data = {})
    self.payment_info.populate(data)
    self.payment_info.continue
    wait_for_ajax
  end

  def populate_credit_card_with(card_type, card_number, cvv)
    # demonstrate manual population of data
    self.payment_info.cc_name = "John Smith"
    self.payment_info.cc_type = card_type
    self.payment_info.cc_number = card_number
    self.payment_info.cc_cvc = cvv
    self.payment_info.cc_month = '12'
    self.payment_info.cc_year = '2025'
    self.payment_info.continue
    wait_for_ajax
  end
end
