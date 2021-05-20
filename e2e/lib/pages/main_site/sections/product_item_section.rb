# frozen_string_literal: true

class ProductItem < BasePage
  h2(:product_title, class: 'product-title')
  div(:product_description, class: 'description')
  span(:price, class: %w(price actual-price))
  button(:add_to_cart, value: 'Add to cart')
  button(:add_to_compare_list, value: 'Add to compare list')
  button(:add_to_wishlist, value: 'Add to wishlist')
end
