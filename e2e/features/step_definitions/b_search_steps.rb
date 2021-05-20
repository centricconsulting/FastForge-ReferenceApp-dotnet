# frozen_string_literal: true

And(/^I have searched for specific (.*)$/) do |product|
  on_page MainPage do |page|
    page.store_header.search_for product
  end
end

# for inline feature demo
And(/^I have searched for$/) do |table|
  # table is a table.hashes.keys # => [:search_field]
  on_page MainPage do |page|
    table.hashes.each do |h|
      page.store_header.search_for h.cleaned
    end
  end
end

# for fixture feature demo
