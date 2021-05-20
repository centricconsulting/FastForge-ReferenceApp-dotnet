# Documentation Guidelines

The Centric automation framework uses [Yard](https://yardoc.org/) to generate documentation from source code.  Helper functions should be documented appropriately.    If your methods and their parameters are named appropriately then the documentation requirements are minimal.  You don't need to go overboard, but the return values should at least be documented.

Some examples:

```ruby
# @return [Watir::Browser] a new browser based on tags in the scenario
def self.create_browser(scenario)	
```
Based on the name, it's clear what this step does so no need to repeat that.  The parameter name makes it clear that it accepts a scenario object. So documenting the return value is sufficient.

```ruby
# Opens the list of subscriptions if not already open
# @return [Nil]
def open_subscriptions
```
While the name is mostly clear, the caveat that it does nothing if the subscriptions are already open was worth noting.

```ruby
#
# Construct a new page object.  Prior to browser initialization it will call
# a method named initialize_accessors if it exists. Upon initialization of
# the page it will call a method named initialize_page if it exists.
#
# @param root [Watir::Browser, Watir::HTMLElement, Selenium::WebDriver::Driver, Selenium::WebDriver::Element] the platform browser/element to use
# @param visit [bool] open the page if page_url is set
# @param parent [PageObject] - The parent Page
def initialize(root, visit = false, parent = nil)
```

Here we need to inform the user that there are additional initialization functions that are callable.  We also need to clearly document our parameters as they're somewhat complicated.

### For more information
You can do a find in files for @return or @param to see how documentation is currently implemented.  The Yard [getting started](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md) guide can be very helpful as well.

### Generating documentation
To build documentation run the command `rake yard` from the root directory of the project.