# Hookable accessors

This framework includes an extension to PageObject that integrates the [Captain Hook](https://github.com/Donavan/cpt_hook) gem into the PageObject DSL.  With Captain Hook we can add before/after hooks to elements and DRY up our code. 

## How it works

The DSL is extended to add a "\_hooked" version for each of the traditional accessors.  These function identically to the original accessors except that they accept a "hooks" parameter that is used to wrap the element.  They add the same methods to your page as before and add one additional method "\_element\_unhooked" which allows you to access a pure element without any hooks applied.

## Defining hooks

The Hookable DSL features two main keywords that serve as the primary interface as well as a handful of keywords that add context.

* **before** - Used to start a before hook
* **after** - Used to start an after hook
* **call** - Used to indicate which method to call as part of the hook.  This can be a symbol, proc, or lambda.
* **with** - Used to provide arguments to the call.  Procs and lambdas can be supplied to resolve params at runtime.
* **using** - Used to indicate where the method to call "lives".  Again proc and lambdas can be supplied.  By default, the element is checked for the method to call as well as the page.

Putting those together we get something like:

```ruby
contacts_menu_hooks = define_hooks do
  before(:click).call(:ensure_visible).with(:contacts)
  after(:click).call(:wait_for_ajax)
end

link_hooked(:view_businesses, text: 'View Businesses', hooks: contacts_menu_hooks)
```

The the above code we can call `page.view_businesses` without first ensuring that the contacts menu has been made visible.  Likewise we know that `wait_for_ajax` will be called whenever the link is clicked.

Hooks can be combined via a merge method.  For example, since we have a common set of hooks defined as `WFA_HOOKS` that cover methods that are likely to trigger AJAX, the above could be written as:

```ruby
contacts_menu_hooks = define_hooks do
  before(:click).call(:ensure_visible).with(:contacts)
end

link_hooked(:view_businesses, text: 'View Businesses', hooks: contacts_menu_hooks.merge(WFA_HOOKS)
```

### Common hooks

The file lib/element_hooks.rb contains hooks that are likely to used by multiple pages.  That's where `WFA_HOOKS` lives.

## When to use hooks
If you have a sequence of actions that must always be performed before accessing an element, that's a good indicator hooks can help you.  Like in the above example, we can't click a link in the dropdown unless the dropdown has been toggled to its open state.  So we make sure that we call `ensure_visible(:contacts)` on the page before trying to click the element.

If your element would trigger an AJAX call you **must** use a hooked accessor to apply the `WFA_HOOKS` to it.  This avoids a lot of duplication and ensures that the page is in a usable state before control returns to the caller.



