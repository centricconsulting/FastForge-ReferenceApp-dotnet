# Selectors and timing

## Accessing elements on the pages

Many of the elements you're working with will not have an ID or name associated with them.   While this would normally make like difficult for us, WorkCenter makes use of the Knockout javascript library allowing us to find elements based on their knockout bindings. For example, the declaration below for the save_route button has a knockout binding that calls "saveRoute" on click, allowing us to uniquely identify it.

```ruby
button_hooked(:save_route, data_bind: /click: saveRoute/, hooks: WFO_HOOKS) 
```

Note that this is also declared as button_hooked, not button.  It also has a hooks option at the end.  This is a custom extension for PageObject that allows us to perform actions before / after methods are called on the element.

## Managing timing issues 
### Captain Hook
By using the hooked accessors extension we can make it easier on ourselves to managing timing issues, and repetitive actions.

The file lib/element\_hooks.rb contains hook definitions for common actions.  Of particular interest are WFA\_HOOKS and WFO\_HOOKS.  These hooks ensure that wait\_for\_ajax or wait\_for\_overlay get called for actions that would trigger ajax calls.  (Note: WFO, includes WFA so you only need one) By using these hooks we ensure that we can't ever forget to wait properly, and we save ourselves some typing.

These hooks can help DRY up our code:

```ruby
AM_HOOKS ||= define_hooks do 
  before(:click).call(:ensure_action_menu_open)
end

link_hooked(:add_territory, data_bind: /click: addTerritory/, hooks: AM_HOOKS.merge(WFA_HOOKS)) 
```


With this we can make sure our action menu is open before attempting to click any of the links contained in it.  We also perform a WFA.


### BasePage
The BasePage class defines several helper methods for dealing with timing:

* wait\_for\_overlay - Will block until any overlays disappear.
* dismiss\_toasts - Will remove any active toasts.
* dismiss\_expected\_toasts - Will block until toasts appear then dismiss them.
* wait\_till\_loaded - Will block until the page has been fully loaded.  Subclasses must define a 'loaded?' function to ensure this works properly.

### CSS State
The CSS state extension	 allows us to define states for elements based on their CSS classes.  For example:

```ruby
link(:show_contacts, data_bind: /ShowContacts/)
css_state(:show_contacts, { open: 'k-minus', closed: 'k-plus', default: :closed })
```

The show_contacts link can either be opened or closed.  Clicking it toggles this state.  With this we can do something like the following:

```ruby
show_contacts unless show_contacts_open?
```

Or:

```ruby
wait_until(5, 'Contacts did not open') { show_contacts_open? }
```
  