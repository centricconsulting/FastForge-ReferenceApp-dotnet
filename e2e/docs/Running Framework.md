# Running from Command Line
Set environment variable defaults via [features/support/nenv_vars.rb](features/support/nenv_vars.rb)
These are overridden by set environment variables either through environment variables or via cucumber.yml (in that order)

```bash
set BROWSER_TYPE=local
set BROWSER_BRAND=firefox
cucumber "C:/rubyprojects/pure_insurance/features/PURE Demo/pure_fnol_auto_demo.feature" -p chrome -p json
```
BROWSER_RESOLUTION will be 1920x1080 because that's default in nenv_vars.
BROWSER_BRAND will end up being chrome, because even though the enrivonrment variable is set, it is overridden
by [cucumber.yml](cucumber.yml).  Otherwise, it would launch firefox.  Default is chrome

```bash
bundle exec cucumber "C:/rubyprojects/pure_insurance/features/PURE Demo/pure_fnol_auto_demo.feature" -p default -p chrome
bundle exec cucumber "C:/rubyprojects/pure_insurance/features/PURE Demo/pure_fnol_auto_claim_components.feature" -p default -p chrome
bundle exec cucumber "C:/rubyprojects/pure_insurance/features/PURE Demo/pure_fnol_home_demo.feature" -p default -p chrome
```

Other cucumber running options can be read about at
[https://cucumber.io/docs/](https://cucumber.io/docs/) 

or when using RubyMine
[https://www.jetbrains.com/help/ruby/cucumber-support.html](https://www.jetbrains.com/help/ruby/cucumber-support.html)