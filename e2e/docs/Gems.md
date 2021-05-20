<!--
# @markup markdown
# @title Gems in the Centric framework.
# 
-->
# Gems in the Centric framework.

The gems included have their versions locked to only allow minor updates. If major version updates are desired those updates should be performed intentionally and only after having tested to ensure no breaking changes have been made.

### Core
* **[Watir](https://rubygems.org/gems/watir/versions/5.0.0)** Automated testing tool for web applications. By Testers. For Testers.
* **[RSpec Expectations](https://rubygems.org/gems/rspec-expectations)** provides a simple, readable API to express expected outcomes. i.e. expect(foo).to be_truthy
* **[Page Object](https://rubygems.org/gems/page-object)** A DSL that works with Watir to provide a clean interface for browser automation.
* **[Data Magic](https://rubygems.org/gems/data_magic)** provides datasets, stored in YAML files. Works well with Page Object.
* **[Sauce Whisk](https://rubygems.org/gems/sauce_whisk)** A Wrapper for the Sauce Labs REST API.
* **[Cuke Cataloger](https://rubygems.org/gems/cuke_cataloger)** A convenient way to provide a unique id to every test case in your suite. Unlike Cucumber IDs, these don't change when lines are added to the Gherkin.
 
### Development / Debugging
* **[Rake](https://rubygems.org/gems/rake)** A Make-like program implemented in Ruby. See the documentation on rake tasks for more information. 
* **[Pry](https://rubygems.org/gems/pry)** An IRB alternative and runtime developer console.  If you're not familiar with Pry, the [screencasts](http://pryrepl.org/screencasts.html) are a great introduction to this powerful tool.
* **[Pry Byebug](https://rubygems.org/gems/pry-byebug)** Adds 'step', 'next', 'finish', 'continue' and 'break' commands to Pry.
* **[Pry Stack Explorer](https://rubygems.org/gems/pry-stack_explorer)** Walk the stack in a Pry session. Adds the 'show-stack' command to Pry.

### Code Quality
* **[rubocop](https://rubygems.org/gems/rubocop)** Automatic Ruby code style checking tool.  Rubocop will help ensure that your code stays clean and maintainable.
* **[Overcommit](https://rubygems.org/gems/overcommit)** A utility to install, configure, and extend Git hooks.  With overcommit we can ensure that code analysis tools are run before code is pushed.
* **[Yard](https://rubygems.org/gems/yard)** A documentation generation tool for Ruby that can generate documentation from code comments. Core framework and "helper" code should be documented via Yard.

### Utility / Misc 
* **[Facets](https://rubygems.org/gems/facets)** The premier collection of extension methods for Ruby. They are stored in individual files so that you're not bloated with exentions you don't use. Several of their string extensions make constructing element names and page class names from English much cleaner.
* **[Nenv](https://rubygems.org/gems/nenv)** A convenient wrapper for Ruby's ENV.  The file [features/support/helpers/nenv.rb](features/support/helpers/nenv.rb) contains the nenv variables used in the framework.