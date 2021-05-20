# Working with tables and grids
The Centric applications make use of numerous tables and grids. Instead of treating their contents as part of the main page these should be broken in to sections.  One section for the grid itself, another for the contents.

An example of this is the BusinessSearchList:

```ruby
# This represents a single row in the "business search" grid
# All selectors are relative to the tr
class BusinessSearchRow < BasePage
  checkbox(:selected, xpath: 'td[1]/input')
  link(:show_contacts, data_bind: /ShowContacts/)
  css_state(:show_contacts, { open: 'k-minus', closed: 'k-plus', default: :closed })
  span(:org_name, data_bind: 'html:OrganizationName')
  span(:address, data_bind: 'text:Address')
end

class BusinessSearchList < BasePage
  # Map the tr elements with business data in them to our section class
  def results
    trs(data_bind: /assignedCssClass/).map { |r| BusinessSearchRow.new(r) }
  end
end
```

This allows us to do something like the following:

```Ruby
page.business_list.results.first.org_name
```