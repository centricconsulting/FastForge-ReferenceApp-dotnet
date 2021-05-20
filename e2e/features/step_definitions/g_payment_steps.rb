# frozen_string_literal: true

# Payment - inline demo
And(/^I pay via$/) do |table|
  # table is a table.hashes.keys # => [:cc_type, :account, :cvv, :cc_month, :cc_year]
  on_page(CheckoutPage) do |page|
    table.hashes.each do |h|
      page.populate_credit_card h.cleaned
    end
  end
end

# payment - outline demo
And(/^I pay via a (.*) using (.*) with (.*)$/) do |cc_type, account, cvv|
  on_page(CheckoutPage) do |page|
    page.populate_credit_card_with cc_type, account, cvv
  end
end

# Payment - Fixture Demo
And(/^I enter payment information$/) do
  # this is shortcut
  on_page(CheckoutPage, &:populate_credit_card)
  # for this
  # on_page(CheckoutPage) do |page|
  #   page.populate_credit_card
  # end
end
