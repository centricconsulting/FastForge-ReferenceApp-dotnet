# frozen_string_literal: true

# Confirmation steps
And(/^I confirm order totalling (.*)$/) do |total|
  on_page CheckoutPage do |page|
    t = page.confirm_order.cart_costs
    expect(t[:total]).to eq(total), "Order contained the following data #{t}. I found #{t[:total]}, but I was expecting a total of #{total}"
    page.confirm_order.confirm
    page.wait_for_ajax
  end
end

Then(/^I will receive a confirmation$/) do
  on_page CheckoutCompletePage do |page|
    expect(page.order_number.gsub('ORDER NUMBER: ' , '').to_i).to be > 0, "Expected valid order number.  However found #{page.order_number} instead"
  end
end
