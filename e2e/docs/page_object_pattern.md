# Page Object guidelines for the Centric framework

* The PageObject should be the only place where DOM manipulation occurs.
* Page Object source files should be placed in lib/pages/<PRODUCT>
* Complicated pages should be broken up into page sections.
* Modal dialogs should be broken up into page sections.
* "Drop down" lists made up of divs / lis should be broken out into page sections.  In many cases you'll be able to use the generic ULSelect section either outright or as a base class for your list.
* Page Sections should be placed in a "sections" folder under the pages the section belongs to.
* The data to populate pages / sections from fixtures must use a key that represents the "snake case" of the page /section class name.  e.g. "complete\_sales\_call\_modal" for CompleteSalesCallModal


## Keeping the logic in your steps simple
If an action would trigger an AJAX call, navigation, animation, etc then that should be handled inside the page class.  If an action requires that another action be performed first that should also be handled inside the page class.

For example let's assume that we have a field that turns into an edit box when clicked and a save button that triggers ajax.  Instead of something like:

```ruby
on(Pageclass) do |page|
	page.foo_element.click
	page.foo = 'bar'
	page.save
	page.wait_for_ajax
end
```

We can add methods to the page like so:

```ruby
def foo=(value)
	foo_element.click
	foo_elelment.value = 'bar'
end

def save
	save_element.click
	wait_for_ajax
end
```

Which allows us to use simpler logic in our step like so:

```ruby
on(Pageclass) do |page|
	page.foo = 'bar'
	page.save
end
```

Doing this many times can be tedious. For that reason the Centric framework includes a page object extension too make things easier.  See the file README_HOOKS.md for details.


## Managing state with css_state
Quite often you'll encounter things like dropdown lists which may or may not be expanded, open, etc.  If you inspect the elements you'll usually find that classes are added or removed as the state changes.  In order to make our code cleaner and easier to read the Centric framework includes an extension to the PageObject DSL that adds the keyword css_state.

The css_state method accepts another element as it's first argument and then a hash containing state names and the CSS classes that represent those states.  For example:

```ruby
link(:show_contacts, data_bind: /ShowContacts/)
css_state(:show_contacts, open: 'k-minus', closed: 'k-plus')
```
Here we've defined a link called "show\_contacts".  We've all defined two states "open" and "closed" and the CSS classes associated with those states. 

With that in place we can query the state of that element with "ELEMENT_STATE?" where ELEMENT is the element name and STATE is one of the states we've defined.  For example:

```ruby
page.show_contacts_open?
```

Quite often you'll encounter elements that only have a CSS class for one of their states.  In those cases you can define an additional state as the absence of a class.  For example:

```ruby
  li(:contacts_menu_dropdown, xpath: '//*[@id="sp-navbar"]/ul/li[1]')
  css_state(:contacts_menu_dropdown, open: 'open', closed: { not: 'open' })
```

When the dropdown is open the CSS class "open" is applied.  When it's closed the "open" CSS class is removed, but no "closed" class appears.  By passing a hash with the keyword "not" we can pass a class name that should be missing in order for the element to be in this state. 


## Working with sections
Pages can be complicated.  Breaking pages into sections is nearly mandatory for most pages.  

Since many pages have similar sections that could cause name conflicts sections for pages should be placed in a module and that module included in the class.  For example the "Add Route Stop Modal" (lib/pages/workcenter\_marketing/sections/add\_route\_stop_modal.rb) is composed of multiple sections. These sections are in several files.  Each file defines classes within the AddRouteStopSections module.  The AddRouteStopModal class includes that module, ensuring that the section class names cannot clash with sections for other pages.

### Section parents
The Centric framework uses an extension to PageObject that preserves the parent / child relationship of sections.  Methods within a section can use the "parent\_page" accessor to access their parent page.  For example, the following code uses this feature to make sure that the list of contacts is being displayed before we try and access any data contained in the rows:

```ruby
def contacts
  # Make sure the parent row has made us visible
  parent_page.show_contacts unless parent_page.show_contacts_open?
  contacts_grid_element.tbody.trs.map { |row| RBLContactGridRow.new(row) }
end
```



### Sections for grids
Using page sections for grids / lists makes it easier for us to access the contents of the grids as logical entities.  It's possible to use page sections without using the PageObject DSL to declare them. The file lib/pages/workcenter\_marketing/sections/route\_business\_list.rb contains a good example of a somewhat complex implementation of this pattern.  The pattern can be broken down as follows:

1. Create a page section for the grid itself.
2. Create a page section for the data contained in the row.
3. Within the section for the grid, create an "items" method that maps the rows into the proper class
4. Create appropriate "find" methods in the grid section.

The following code is an example of this in action:

```ruby
  # This represents a single row in the contacts grid, of a RBLContactsRow
  # All selectors are relative to the tr
  class RBLContactGridRow
    include PageObject
    span(:contact_name, data_bind: 'text:Name')
    span(:address, data_bind: 'text:Address')
  end

  # This represents a single row in the "business search" grid, for rows that contain contacts
  # All selectors are relative to the tr
  class RBLContactsRow
    include PageObject
    div(:contacts_grid, id: 'divContactsGrid')

    def contacts
      # Make sure the parent row has made us visible
      parent_page.show_contacts unless parent_page.show_contacts_open?
      contacts_grid_element.tbody.trs.map { |row| RBLContactGridRow.new(row) }
    end

    def find_contact(name)
      contacts.find { |c| c.contact_name == name }
    end
  end
```



### External page sections
Quite often you will encounter drop down lists that appear to be contained within a section, but actually live outside div containing the rest of the elements.  A good example of this would be many of the drop down lists.

To help deal with this issue we have an extension that allows us to declare a subsection that's not constrained to the DOM of the section.  In addition to the normal page\_section parameters an additional parameter is available to indicate the actual parent of the section within the DOM.  This parameter should be a symbol that refers to a function on the page object that returns the proper parent.  In many cases the symbol :parent\_page is what you'll want to use:

```ruby
external_page_section(:was_productive_visit_list, ULSelect, :parent_browser, id: 'lstProductiveVisit_listbox')
```