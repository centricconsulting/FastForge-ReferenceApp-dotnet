# frozen_string_literal: true

# Shipping - inline demo
And(/^I ship to, via shipping method$/) do |table|
  # table is a table.hashes.keys # => [:shipping_address_select, :shipping_method]
  on_page(CheckoutPage) do |page|
    table.hashes.each do |h|
      page.populate_shipping h.cleaned
      page.populate_shipping_method h.cleaned
    end
  end
end

# shipping - outline demo
And(/^I select (.*) shipping$/) do |shipping|
  on_page(CheckoutPage) do |page|
    # For now, we're going to accept the current ship to address
    page.populate_shipping
    page.populate_shipping_method shipping
  end
end

# Shipping - fixture demo
And(/^I select the shipping method$/) do
  on_page(CheckoutPage) do |page|
    page.populate_shipping
    page.populate_shipping_method data_for(:shipping_method_section)["shipping"]
  end
end
