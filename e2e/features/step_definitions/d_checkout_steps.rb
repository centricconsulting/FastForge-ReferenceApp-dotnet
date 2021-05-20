# frozen_string_literal: true

# Checkout Start Process Steps
And(/^I begin the checkout process as a guest$/) do
  on_page(ShoppingCartStartPage) do |page|
    page.open_cart
    page.wait_for_ajax
    page.checkout
  end

  on_page(CustomerGuestSigninPage) do |page|
    page.change_page_using(:checkout_as_guest)
  end
end
