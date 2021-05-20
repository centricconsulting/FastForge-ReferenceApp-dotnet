# frozen_string_literal: true

And(/^I have added (.*) to my cart$/) do |product_title|
  on_page ProductListPage do |page|
    page.add_product_to_cart product_title
  end
end
