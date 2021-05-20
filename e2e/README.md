# Centric Automation Framework

## Overview

The Centric Automation Framework leverages Watir using the Page-Object Design Pattern.  Some benefits over this framework vs. out of the box frameworks

- It is capable of running tests in parallel
- Built-in support for running mobile tests
- Built-in support for running in cloud provides, e.g. Saucelabs
- Additional extensions to provide several ways to manage data [./docs/Managing Test Data.md](./docs/Managing Test Data.md)



is comprised of several key elements.

1. Environmental Variables and Profiles
2. Architectural Patterns
3. Test Data Patterns



## Stepping through tests
The environment variable CUKE\_STEP\_SIZE will allow you to step through your tests. At each CUKE\_STEP\_SIZE step, you will be prompted to press a return to continue.

Fore example, to stop at each step you would use:
```
CUKE_STEP_SIZE=1 bundle exec cucumber 
```

## Debugging
In addition to the RubyMine debugger, Byebug, Pry and several Pry plugins are in the Gemfile.  Pry is an excellent tool for exploritory development.

If you are unfamiliar with Pry it's worth taking the time to get to know it.  Visit the [Pry website](http://pryrepl.org/) for details.

To drop into a Pry session when a test fails, set _CUKE\_DEBUG_ to true or use the _debug_ profile.


## Screenshots
In the event of a test failure, a screenshot of the current page will be saved in the screenshots folder under the project root. (If the folder does not exist it will be created)

The screenshot will also be embedded in the results file (if any).

## Output Formats
Be default, results will be saved in json format with a filename that matches the pattern of test_TEST\_ENV\_NUMBER_.json.  This file can be used by various tools to produce reports.

If you are not using the default profile you will need to pass -p json to receive json output.

There are additional see the profiles section for information on other output options.