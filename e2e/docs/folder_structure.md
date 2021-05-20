# Centric automation folder structure 

The folder structure for this project is a little different than the cucumber default. Code that is not directly used by Cucumber (i.e. not a stepdef, hook or part of the env.rb) lives under the lib folder, not in a child of the features folder.

This is done to minimize startup times.  Cucumber does not "require" most files it loads them.  This means some files can be loaded multiple times.

## Important folders

1. **/docs** - Contains documentation
2. **/config/drivers** - Contains the web driver binaries.  These will be automatically added to your path.
3. **/features** - Root for the feature files.  Features are further divided under here by product.
4. **/features/support** - Contains support files required by cucumber such as _env.rb_ and _hooks.rb_.
5. **/fixtures** - Contains YML data for features.
6. **/lib/extensions** - Contains extensions / "monkey patches" to gems used by the suite.
7. **/lib/helpers** - Contains helper modules. 
8. **/lib/pages** - Contains page objects and sections.  These should be organized by product.
9. **/lib/pages/sections** - Contains page objects for page_sections.  

## Where to place files

Features should be placed in a folder under features that corresponds to the product being tested. e.g. features/workcenter_marketing

Step definitions should be placed in [./features/step_definitions](./features/step_definitions).

All other code should be placed in the appropriate folder, using the "important folders" section as a guide.

## How to name files

All files, other than README files should be in all lower case, with underscores in place of spaces. This allows us to avoid escaping path names and ensure that file names are consistent for case sensitive file systems.