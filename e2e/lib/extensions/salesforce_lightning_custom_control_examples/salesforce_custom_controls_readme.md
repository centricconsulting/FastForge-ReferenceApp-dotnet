Salesforce Lightning has several controls that make automation difficult

# Non-Standard Web Elements
A Dropdown list is not a real drop down list.  It is a combination of a div tag with a child link
that is styled to look like a textbox.  Since it is not an input field, you cannot set it.
The actions required are to click the div, then a popup panel displays a list of unordered
links.  You must select from that list to complete the selection.  As a result a custom PageObject 
control was created in [lib/extensions/salesforce_lightning/lightning_dropdown.rb](lib/extensions/salesforce_lightning/lightning_dropdown.rb)

Declare it and use it
```ruby
class MyPage
    # Often in SF, the field has no descriptor, so you must reference the parent label
    # and find the child link.  This declaration is as so:
    sf_dropdown(:account_type) { span(text: 'Type').parent.link }

    # alternately, a regular declaration is just like normal
    sf_dropdown(:homeowner_type, id: 'dd_homeowner')
    
    def set_account_type(value)
      self.set_account_type = 'Prospect'
    end

    def set_homeowner_type(value)
      self.set_homeowner_type = 'Renter'
    end
end
```

Be aware, when debugging, you cannot call `@browser.sf_dropdown(id: 'homeowner_type)` as this control does not exist
in WATIR.  It only exists as a declarative control in PageObject.  You can debug, while in the class, by
calling the page object item itself, for example: `self.homeowner_type_element.present?`

## Making your own PageObject Controls
Use the referenced file above as a template.  The big thing is to path PageObject-->Accessors
so that you can declare the page_object accessor
```ruby
module PageObject
    module Accessors
      def name_of_my_control(name, identifier = { index: 0 }, &block)
        define_method(name) do
          send("#{name}_element").text
        end
      end
    end
end

```
Now you can declare and use your page object control
```ruby
class MyPage
    name_of_my_control(:human_readable_name, id: 'crazy_id_from_developers')
    
    def get_text_from_my_control
      # returns the text of the element
      self.human_readable_name
    end
end
```

DON'T FORGET to add a reference to this file to your [lib/extensions.rb](lib/extensions.rb) file


# Custom HTML Tags
Salesforce has many custom HTML tags (as well as attributes, but we can already leverage those natively).
Custom tags come in many forms.  For example, here is the html for a navigation bar tab

```html
<one-app-nav-bar-item-root one-appnavbar_appnavbar="" data-id="home" data-assistive-id="operationId" aria-hidden="false" draggable="false" class="navItem slds-context-bar__item slds-shrink-none" role="listitem"><a href="/lightning/page/home" title="Home" tabindex="0" draggable="false" class="slds-context-bar__label-action dndItem"><span class="slds-truncate">Home</span></a></one-app-nav-bar-item-root>
<one-app-nav-bar-item-root one-appnavbar_appnavbar="" data-id="Feed" data-assistive-id="operationId" aria-hidden="false" draggable="false" class="navItem slds-context-bar__item slds-shrink-none" role="listitem"><a href="/lightning/page/chatter" title="Chatter" tabindex="0" draggable="false" class="slds-context-bar__label-action dndItem"><span class="slds-truncate">Chatter</span></a></one-app-nav-bar-item-root>

```

These do not work natively in WATIR nor do they work natively with PageObject.
See [lib/extensions/salesforce_lightning/nav_bar_item.rb](lib/extensions/salesforce_lightning/nav_bar_item.rb) for an example

This is a multi-step process
### Create a file for the custom control, include the required libraries
```ruby
# frozen_string_literal: true

require 'cpt_hook'
require 'page-object/accessors'
require 'lib/helpers/widget_register'

# Declare your custom element - This adds your tag to the Watir::Element Class as an individual element and a collection
Watir::Container.register_custom_element('one_app_nav_bar_item_root','one_app_nav_bar_item_roots','OneAppNavBarItemRoot','Element')

```
The big thing here is to declare your custom tag by using this call
```ruby
Watir::Container.register_custom_element('one_app_nav_bar_item_root','one_app_nav_bar_item_roots','OneAppNavBarItemRoot','Element')

```
The values passed in are `element_tag, element_pluralized, element_class, inherit_from_element = Element`
* element_tag - this is the custom HTML tag
* element_pluralized - this is how to refer to a collection of the custom HTML tags
* inherit_from_element - this is a type of element to inherit traits from, by default it is Element

### Now we need to add to WATIR to so we can make calls like
```ruby
@browser.one_app_nav_bar_item_root(id: 'crazy_dev_id').present?
```
To do that, we need to add call watir methods for both the individual tag and collections
```ruby
module PageObject
  module Platforms
    module Watir
      # Modify the PageObject class to add in calls to locate the new element or a collection of the new elements
      class PageObject
        def one_app_nav_bar_item_root_for(identifier)
          find_watir_element("one_app_nav_bar_item_root(identifier)", Elements::Element, identifier, 'one_app_nav_bar_item_root')
        end

        def one_app_nav_bar_item_roots_for(identifier)
          find_watir_elements("one_app_nav_bar_item_roots(identifier)", Elements::Element, identifier, 'one_app_nav_bar_item_roots')
        end
      end
    end
  end
end 
```
### Now we need to add it to Page Object Accessors so we can declare and interact with it
```ruby
module PageObject
    module Accessors
      def one_app_nav_bar_item_root(name, identifier, &block)
        # This next line is required!  Otherwise, PageObject won't be able to find the _element calls
        standard_methods(name, identifier, 'one_app_nav_bar_item_root_for', &block)
        
        define_method(name) do
          self.send("#{name}_element")
        end
      end
    end
end
```
A key thing here is the `standard_methods` line, it is required and it references the method `one_app_nav_bar_item_root_for'
created in step #2.  Without this line, PageObject won't know how to make a call to locate the custom tag

### Now you're all set to use the custom html tag as a item
```ruby
class MyPage
    one_app_nav_bar_item_root(:current_focused_tab, class: 'slds-is-active')

    def currently_focused_tab_area
      self.current_focused_tab.text
    end
end

```
You can also now use `@browser.one_app_nav_bar_item_root(class: 'slds-is-active').present?` with this class

DON'T FORGET to add a reference to this file to your [lib/extensions.rb](lib/extensions.rb) file


# Empty HTML attributes
Some HTML tags have attributes with no value
```html
<div one-appnavbar_appnavbar="" role="list" aria-describedby="operationId-12" class="slds-grid slds-has-flexi-truncate navUL"></div>
```

to declare, we need to empty quotes such as below
```ruby

div(:tab_nav_area, 'one-appnavbar_appnavbar' => '')
```

As an aside, normally for custom attributes, we can use symbols if the attribute contains all hypens '-', such as 
`data-data-rendering-service-uid` would be `:data_data_rendering_service_uid` but when hypens and underscores are natively
mixed, we must use the string instead, like in the example above

