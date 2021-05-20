# Native Mobile Automation

This document is not yet complete.  The native mobile framework is currently under heavy development and will be documented here once the API is stable and patterns have emerged. However there are some stable elements which can be documented.

## Introduction

### Getting set up
In order to run / develop native mobile tests you will need [Appium Desktop installed](http://appium.io/docs/en/about-appium/getting-started/).  I recommend downloading the desktop version if you're doing development as it includes tools that you'll need.  For iOS you will need Xcode and the command line tools installed, there's a list of prerequisites and how to install them in the [documentation](http://appium.io/docs/en/drivers/ios-xcuitest/index.html) for the XCUI driver.

Note: Depending on where you end up installing XCode, Appium may not be able to find it.  When installing via the App Store, on at least one machine, Appium was not able to find XCode.  There is a simple fix for this, enter the following on the command line: `sudo xcode-select --switch /path/to/Xcode.app` for example if Xcode is installed in /Applications you would use `sudo xcode-select --switch /Applications/Xcode.app`		` 

### Mobile application locations
Whenever a new build of a mobile application is delivered the app should be zipped and placed in the `mobile_apps` folder of the project.  These apps should be checked into git so that they're available to anyone that needs to run the mobile tests.

### Running mobile tests
Mobile tests can be run using one of the mobile profiles such as `ios_native_mobile` or `android_native_mobile`.  This sets up the proper flags to tell the framework to load mobile testing support.

### Installing a new version of a mobile app
In order to install a new build of a mobile app onto your emulator add `RESET_MOBILE=true` to your cucum command line, then run a simple test like the login test.  For example: `bundle exec cucumber RESET_MOBILE=true -p ios_native_mobile features/Mobile/chris_wip/wcmm.feature:10`

### Handy links for learning mobile automation
https://appiumpro.com/editions/8

## Things to know about native mobile testing

### The inspector tool
The inspector	tool built into Appium is the easiest equivalent to "view source" or the Chrome dev tools.  You can launch it from Appium Desktop once you've started your server.  You can set it up to load the app you want to work with, but it's easier to set a pry breakpoint in your test and attach to the session.

You will spend a lot of time in this control as you're building your ScreenObjects.  With it you can find the accessibility IDs, hierarchy and much more. Invest some time into getting to know how it works it's MUCH better than digging through raw XML to find what you're looking for.

### The tools are less refined
* Scrolling is manual.  If you need to interact with something, you must scroll to it yourself.
* Things can be displayed and hidden at the same time. If the onscreen keyboard (OSK) is up and covering a control, it will report as displayed but you will not be able to interact with it.
* There's no way to ask if something exists other than trying to, and failing to, find it.  This can take quite a bit of time, depending on timeout settings.
* find\_element will only find visible controls.  This includes list items.
* find\_elements *will* find controls that aren't visible. If you're looking for an control which might need scrolled to, you're better off using find_elements and grabbing the first one.
* How you locate things has serious performance issues.

### Locating controls in iOS apps
There are several ways to locate controls, each has it's advantages and disadvantages.

* accessibility\_id can be the fastest and most reliable way to find controls.  However, if the developer has not given an explicit accessibility\_id to a control, one will be generated for it based on the content of the control. You might find a text\_field via `address1` but once you change the value of the text\_field that ID is now `123 main st` or something similar.  **They're very handy for buttons and static text, however use caution with controls that have values that change.**
* Finding elements by index is also very fast.  However, the order of controls cannot change for this to be accurate.  If you have dynamic content, where controls are added and removed, you can only reliably locate controls before the dynamic area.
* Finding elements by class chain is slightly slower than the above two.  It has the advantage of being precise.  When dealing with dynamic content class chains allow you to use an xpath-like syntax.
* Predicate strings have similar performance to class chain lookups.  They use the same underlying mechanism, a class chain is actually a predicate string query.  Predicate string queries typically have to search a larger object space since they can't follow the class chain to narrow their search.
* String queries are "magic" predicate queries.  They will attempt to match your string against several fields.  In most cases you're better off, performance wise, to use a predicate string that only looks at one attribute i.e. `"name == #{value}"`
* XPath is available but should be avoided.  While it's the most precise selector available the performance penalty is quite steep.



## Working with the native mobile framework

The native mobile framework has been designed to look a lot like PageObject from the web automation world.  Instead of PageObjects we have ScreenObjects.  ScreenObjects have an accessor DSL and a populate method.

The framework attempts to mitigate many of the drawbacks of Appium compared to Watir.  Scrolling to controls is handled automatically and presence check functions have been added that temporarily reduce the element location timeouts to a sub second value before checking.  These checks are not as fast as the web based versions, but they're better than nothing.

### Accessors

Most accessors have a signature that accepts a name, an identifier and an index. Their names correspond with their control classes. 

* **text\_field**
* **switch**
* **nav\_bar**
* **table**
* **activity\_indicator**
* **other**
* **image**
* **static\_text**
* **static\_text\_buttton** - Special case where the default method is click.
* **button**
* **switch** - Implemented like a checkbox in Watir.

There are a few special accessors that have different signatures:

* **modal** - This works like page_section in Watir.  You give it a name, an identifier and a screen class to instantiate.
* **popup_table** - Provides an easy abstraction for the various popup lists.  This will be discussed below.
* **date_picker** - Provides an abstraction for DatePickers. **Note:** DatePickers which are added dynamically can not be found due to a bug in Appium.  

### Identifiers
Any identifier that can be passed to find_element can be used in the DSL. The identifiers can be expressed as hash values, or strings. Below are some recipes showing how to use various identifier strategies when declaring controls using the ScreenObject DSL:

***Find the first text\_field on the screen***

```ruby
text_field(:username, 1)
# Adds screen.username and screen.username= to get/set the value
```

***Find the third text\_field with the value of "Street"***

```ruby
text_field(:mailing_address1, value: 'Street', 3)
# Adds screen.username and screen.username= to get/set the value
```

***Find a button by accessibility ID***

```ruby
button(:sign_in, accessibility_id: 'Sign In')
# Adds screen.sign_in to click the button
```

***Find a button by predicate string***

```ruby
button(:sign_in, 
       predicate_string: "type == 'XCUIElementTypeButton' AND value BEGINSWITH[c] 'Sign')
# Adds screen.sign_in to click the button
```


***Find a table using a class chain***

```ruby
TABLE_CHAIN ||= '**/XCUIElementTypeOther[$name=="Add Business"$]/**/XCUIElementTypeTable'
table(:root, class_chain: TABLE_CHAIN)
# Adds screen.swipe_root and screen_scroll_root_to
```
This class chain says "Somewhere in the hierarchy find an 'other' element that has a child with the name 'Add Business', then somewhere under that find a table".  Since most screens have a header with their name, and the first table in the hierarchy below that header contains the controls this definition can be reused in most screens by changing the value to look for in the name attribute.

**Note:** It's helpful to declare part of your class chain as a constant that you can reuse rather than putting the full class chain as the identifier.  This will make things a lot more readable and give you a quick way to see that things have the same parent containers.


***Find a text field in a cell that's in a table***

```ruby
text_field(:business_name, 
           class_chain: "#{TABLE_CHAIN}/XCUIElementTypeCell[2]/XCUIElementTypeTextField")
```
This fill find the first text field, in the second cell, of the table we defined in the `TABLE_CHAIN` constant for the `:root` element.

This is the preferred way to find content in tables that either doesn't have an accessibility ID or has one that changes based on content.

There is an excellent [guide to predicate strings and class chains](https://appiumpro.com/editions/8) on the Appium Pro site.

### Popup Tables
There are many times when you will need to select a value from a popup list. These are similar to select lists in Watir.  Since they all conform to a common structure a special accessor exists to make working with them easier. The `popup_table` accessor has a signature that looks like:

```ruby
popup_table(name, title, identifiers)
```
The `title` attribute is the text that appears in the nav bar for the popup.  The identifiers should include a `toggle` key with an identifier to locate the thing to click in order to show the list, as well as a `value` key, with an identifier to locate the static text field that contains the value after selection.  

The following example shows a complete definition for a popup table.

```ruby
TYPE_CELL ||= "#{TABLE_CHAIN}/XCUIElementTypeCell[3]"
popup_table(:business_type, 'Type', 
            toggle: { class_chain: "#{TYPE_CELL}/XCUIElementTypeButton" }, 
             value: { class_chain: "#{TYPE_CELL}/XCUIElementTypeStaticText" })
# Adds screen.business_type and screen.business_type= to get/set the value            
```

When setting the value of a popup table, the toggle method will be called automatically if the list is not `open?`


### DatePickers
To declare a date picker you need to supply two identifiers.  One for the pickers, the other for the toggle that shows the date picker (if any).

```ruby
VISIT_CELL ||= "#{TABLE_CHAIN}/XCUIElementTypeCell[4]"
date_picker(:next_visit, picker: { class_chain: "#{VISIT_CELL}/**/XCUIElementTypePickerWheel" }, 
                         toggle: { accessibility_id: 'Next Visit Date' }, 
                         scroll: { value: 'Next Visit Date' })
# Adds screen.next_visit and screen.next_visit= to get/set the value
```

DatePickers can accept a Date for their value or a String.  Strings are parsed via Chronic so something like `screen.next_visit_date = 'one month from now'` is perfectly acceptable.  Though `screen.next_visit_date = '8/27/1970'` is also fine.


### Handling scrolling

In order to deal with content that requires scrolling the ScreenObject will make use of a "root" element.  This is the element that will be scrolled to  find the various fields we need to interact with.

In order to scroll to an element, we need to provide additional information in our identifiers passed to the accessors.  We do this with a 'scroll' hash that looks like:

```ruby
scroll: { value: 'Route' }
# or
scroll: { value: "label == 'Physical'" }
```

The first version will scroll until it finds anything with the text 'Route'.  The second will scroll till it finds a label called 'Physical'. ***Scrolling to a label is faster and more accurate.  Use it when you can.***

In most cases all scrolling is contained to a single table, we define this as the "root" element for the screen. Typically this is a table as shown in the accessors example:

```ruby
TABLE_CHAIN ||= '**/XCUIElementTypeOther[$name=="Add Business"$]/**/XCUIElementTypeTable'
table(:root, class_chain: TABLE_CHAIN)
```


We pass scroll information as part of the identifier like so:

```ruby
text_field(:physical_postal_code, 
           scroll: { value: "label == 'Physical'" },
      class_chain: "#{PHYSICAL_ADDRESS_CELL}/XCUIElementTypeTextField[3]")
```

It is possible however to define scroll containers as part of the scroll data like so:

```ruby
table(:some_other_table, 2) # The second table on screen
text_field(:foo, scroll: { value: "label == 'Physical'", 
                       container: :some_other_table }, 
       accessibility_id: 'foo')
```



**Scrolling is terrible** quite often things will scroll to a point where Appium considers them visible, but they can't be interacted with.  In those cases, you can usually use something just below the thing you're looking for instead.

**Scrolling is SLOOOOW** watching Appium scroll to anything is frustrating. When you're scrolling a long list looking for something as text it's doubly so.  Scroll performance is one of the areas under active research for performance for this framework.

### Methods added by the DSL

For all elements the following methods are created on the ScreenObject when declaring controls (Assuming an element named :name):

* **name\_element** - Returns an Appium element or ScreenObject control for the control. Unlike Watir this call accepts a boolean value called `use_cache` which defaults to `true`.  By default controls are cached once found to avoid the overhead of finding the control again. Calling `name_element(false)` will bust the cache and force relocation. If the control does not exist this will take at least .25s to complete.
* **name?** - Returns true if the control is displayed (i.e. this is the same as calling `displayed?` on an Appium element) if the control is hidden, or not present the return value will be false.  This uses the control cache so that once found the only overhead is the call to `displayed?`
* **name\_exist?** - Returns true if the control can be found in the hierarchy regardless of visibility. This control does NOT use the cache and as such is a fairly expensive call to make but this allows it to be used for things that can disappear.  While it does not use the control cache, it does PRIME it.  Calling `name?` after `name_exist?` only incurs the lookup penalty once.
* **name** - Performs the default action for that type of element.   Much like web automation, if it's something that clicks `name` will click it, if it's not a button-like thing, it will return the text of the control.
* **name=** - For controls which can have their values set this method will set them.   This is implemented so that the value parameter is appropriate for the type of controls.  `text_field` accepts strings, `switch` fields accept booleans, `date\_picker` accepts dates or strings.

For controls which have scroll information supplied the following additional methods are added.

* **scroll\_to\_name** - Will scroll `root_element` per the parameters supplied in the identifiers.  This accepts a single parameter indicating the direction to scroll. `:up`, `:down`, `:left`, and `:right` are valid options. The default is `:down` if a direction is not supplied.
* **scroll\_to\_name\_if\_needed** - Calls `scroll_to_name` if `name?` returns false. It accepts the same direction values as `scroll_to_name`.

Tables add a couple more methods related to scrolling:

* **scroll\_name\_to** - Accepts a predicate_string argument the table should be scrolled to and a direction to scroll in, defaults to `:down`.
* **swipe\_name** - Performs a swipe gesture in the supplied direction (defaults to `:down`).  This can also be used to help speed things along in some cases.  For example: If you know the thing you're looking for is far down in a table you might call a swipe call or two first so that the page by page scrolling to text/predicate strings does not have as many pages to go through.  This can also be handy dealing with the imprecise scrolling, ensuring that the last item is fully visible with a quick swipe.

Switches add additional methods:

* **check\_name** - Turns the switch to the 'on' position.
* **uncheck\_name** - Turns the switch to the 'off' position.

Some examples: 

```ruby
# Given this
class DemoScreen
  include ScreenObject

  # This class chain locates the table containing all the fields, we can use it as base for the others
  TABLE_CHAIN ||= '**/XCUIElementTypeOther[$name=="Add Business"$]/**/XCUIElementTypeTable'
  table(:root, class_chain: TABLE_CHAIN)
  text_field(:business_name, class_chain: "#{TABLE_CHAIN}/XCUIElementTypeCell[2]/XCUIElementTypeTextField")
  button(:toggle_type, class_chain: "#{TABLE_CHAIN}/XCUIElementTypeCell[3]/XCUIElementTypeButton")
  switch(:mailing_same_as_physical, scroll: { value: 'Mailing Address is Same as Physical Address' },
                          accessibility_id: 'Mailing Address is Same as Physical Address')
end

screen = on_screen(DemoScreen)
 
# We can:

# Get / set the value of business_name
screen.business_name = 'ABC Co'
name = screen.business_name

# See if business_name is displayed
screen.business_name?

# Click the toggle_type button
screen.toggle_type

# Flip / read the mailing_same_as_physical switch
screen.mailing_same_as_physical = true # Turn the switch on
screen.check_mailing_same_as_physical  # Ditto

screen.mailing_same_as_physical = false # Turn the switch on
screen.uncheck_mailing_same_as_physical # Ditto

actual = screen.mailing_same_as_physical # boolean 

# Make sure the switch is displayed
screen.scroll_to_mailing_same_as_physical

# But don't screw scroll if off screen looking for it, if it's already displayed
screen.scroll_to_mailing_same_as_physical_if_needed

# Scroll the screen to an arbitrary label
screen.scroll_root_to "label == 'foo'"
```
### Populating screens
Everything which include ScreenObject has two ways to populate the controls with data:

**populate_with(data)** - This will take a hash where the keys match the name of controls on the ScreenObject.  Scrolling is only performed in one direction during this call so, data within the hash should be optimized so that keys are sorted in the order in which they appear on the screen. Simply listing them in display order in a YAML file is sufficient.

The `root_element` of the ScreenObject will be scrolled to ensure the control is visible.  Likewise, the on screen keyboard is closed before attempting to set the value of a control.  This means that your machine will make noise while running the tests and the keyboard will act like a Jack Rustle Terrier but it prevents the OSK from blocking controls.

We could populate the screen from the previous example with something like this:

```ruby
screen.populate_with(business_name: 'ABC Co', mailing_same_as_physical: true)

```

**populate(data={})** - This method will call `data_for` from DataMagic using it's class as the key and then merge the results with the passed data, if any.  Keys are built by taking the class of the screen object, stripping the namespacing, then converting to "snake case".  For example `Screens::IOS::WorkCenterMarketing::NewBusinessModal` would pass `new_business_modal` as the key to `data_for`.

We could populate the screen from the previous example with something like this:

```ruby
# Assuming a DataMagic fixture that would have a key 'demo_screen' and the following data:
# business_name: 'ABC Co', mailing_same_as_physical: true

# Populate with the data as-is from the fixture
screen.populate

# Populate with the fixture data, but override some fields
screen.populate_with(business_name: 'ACME Co')

# In this simple example the page would be populated with: 
#  business_name: 'ACME Co', mailing_same_as_physical: true

```
 
### Navigating Screens

Screens should be placed in namespace modules to prevent collision.  These modules should include the OS the screen is for as well as the application name. For example: `Screens::IOS::WorkCenterMarketing::NewBusinessModal` setting `default_app_for_nav` to the name of your application will allow on_screen to find the correct class without your needing to specify the full namespace.  

`on_screen` works just like `on_page` in PageObject, though it can be called in slightly different ways:

```ruby
# These three would all return the same Object assuming that
# @default_app_for_nav is set to 'WorkCenterMarketing' and we're automating iOS
on_screen(:new_business_modal)
on_screen('new_business_modal')
on_screen(Screens::IOS::WorkCenterMarketing::NewBusinessModal)
  
# This would return the exact class passed in.
on_screen(OtherScreen)

# on_screen can be used to fetch a reference to a screen
screen = on_screen(:new_business_modal) 
screen.do_something

# It can be used in the typical block format
on_screen(:new_business_modal) do |screen|
  screen.do_something
  screen.do_something_else
End 

# and it can be used for one-offs 
on_screen(:new_business_modal, &:do_something)  
```