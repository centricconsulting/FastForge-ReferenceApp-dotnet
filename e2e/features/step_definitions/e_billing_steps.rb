# frozen_string_literal: true

# Billing - inline demo
When(/^I enter billing address information$/) do |table|
  # table is a table.hashes.keys # => [:first_name, :last_name, :adress1, :country, :state, :zip, :email, :phone]
  on_page(CheckoutPage) do |page|
    table.hashes.each do |h|
      page.populate_billing h.cleaned
    end
  end
end

# Billing - fixture demo and default page data demo
And(/^I enter (fixture|default) billing address information$/) do |type|
  # by not passing in data, we're relying on default data stored in the page class
  # in this case, it's stored in teh page_section class
  on_page(CheckoutPage).populate_billing
end
