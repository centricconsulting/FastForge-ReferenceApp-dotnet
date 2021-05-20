# frozen_string_literal: true
# Using this for the giant single page field definition area

class BillingSection < BasePage
  text_field(:first_name, id: 'BillingNewAddress_FirstName')
  text_field(:last_name, id: 'BillingNewAddress_LastName')
  text_field(:email, id: 'BillingNewAddress_Email')
  select_list(:country, id: 'BillingNewAddress_CountryId')
  select_list(:state, id: 'BillingNewAddress_StateProvinceId')
  text_field(:city, id: 'BillingNewAddress_City')
  text_field(:address1, id: 'BillingNewAddress_Address1')
  text_field(:zip, id: 'BillingNewAddress_ZipPostalCode')
  text_field(:phone, id: 'BillingNewAddress_PhoneNumber')
  button(:continue, value: 'Continue', visible: true)

  def default_data
    { first_name: 'John',
      last_name: 'Smith',
      country: 'United States',
      state: 'Ohio',
      address1: '123 Main St',
      city: 'Columbus',
      zip: '12345',
      phone: '123-456-7893',
      email: 'kma@hotmail.com' }
  end
end

class ShippingSection < BasePage
  select_list(:shipping_address_select, id: 'shipping-address-select')
  button(:continue, value: 'Continue', visible: true)
end

class ShippingMethodSection < BasePage
  button(:continue, value: 'Continue', visible: true)
  # easier to click labels than dynamic radio's
  def ship_method_select(method)
    self.label(text: Regexp.new(method, Regexp::IGNORECASE)).click
  end

  def get_ship_method_price(method)
    self.label(text: Regexp.new(method, Regexp::IGNORECASE)).text[/.*\(\$(.*)\)/, 1]
  end
end

class PaymentMethodSection < BasePage
  # turned off in application
  # button(:continue, value: 'Continue', visible: true)
end

class PaymentInfoSection < BasePage
  select_list(:cc_type, id: 'CreditCardType')
  text_field(:cc_name, id: 'CardholderName')
  text_field(:cc_number, id: 'CardNumber')
  select_list(:cc_month, id: 'ExpireMonth')
  select_list(:cc_year, id: 'ExpireYear')
  text_field(:cc_cvc, id: 'CardCode')
  button(:continue, value: 'Continue', visible: true)
end

class ConfirmOrderSection < BasePage
  div(:cart_total, class: 'cart-footer')
  td(:sub_total) { cart_total_element.tr(class: 'order-subtotal').td(class: 'cart-total-right') }
  td(:shipping_cost) { cart_total_element.tr(class: 'shipping-cost').td(class: 'cart-total-right') }
  td(:tax) { cart_total_element.tr(class: 'tax-value').td(class: 'cart-total-right') }
  td(:order_total) { cart_total_element.tr(class: 'order-total').td(class: 'cart-total-right') }

  button(:confirm, value: 'Confirm')

  def cart_costs
    {
        subtotal: self.sub_total,
        shipping: self.shipping_cost,
        tax: self.tax,
        total: self.order_total
    }
  end
end
