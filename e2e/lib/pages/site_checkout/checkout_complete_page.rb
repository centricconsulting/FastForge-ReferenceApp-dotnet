# frozen_string_literal: true
# /checkout/completed/
#
class CheckoutCompletePage < BasePage
  div(:order_number, class: 'order-number')
  link(:order_link) { div(class:' details-link').link }
end
