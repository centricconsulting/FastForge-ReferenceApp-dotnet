# frozen_string_literal: true

require_relative 'sections/product_item_section'

class ProductListPage < MainPage
  page_sections(:product_items, ProductItem, class: 'item-box')

  def specific_product(title)
    self.product_items.find { |p| p.product_title == title }
  end

  def add_product_to_cart(product_title)
    product = specific_product(product_title)
    product.add_to_cart
    wait_for_ajax
  end
end
