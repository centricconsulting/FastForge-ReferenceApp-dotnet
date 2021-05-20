# frozen_string_literal: true

class StoreHeader < BasePage

  # fields
  select_list(:currency, id: 'customerCurrency')
  link(:register, text: 'Register')
  link(:login, id: 'Log in')
  link(:wishlist, id: /Wishlist/)
  link(:shoppingcart, text: Regexp.new('Shopping cart', Regexp::IGNORECASE), visible: true)
  text_field(:search_field, id: 'small-searchterms')
  button(:search, value: 'Search')

  # used for passing in hash for searching
  def search_for(data)
    # if incoming data is a hash, use it, otherwise, set field directly.
    data.is_a?(Hash) ? populate(data) : self.search_field = data
    self.search
    wait_for_ajax
  end

  # used for manually searching for term
  def search_for_term(term)
    self.search_field = term
    self.search
    wait_for_ajax
  end
end