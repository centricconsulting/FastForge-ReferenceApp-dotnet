# Overcommit 

We use Overcommit to run quality checks on our codebase before 
code is committed / pushed.  See the code quality guidelines for
more information.

## Installation
After you have done a bundle install, you will need 
to run: `overcommit --install`

Once that is complete, your overcommit config file 
may have been replaced so run: `git checkout .overcommit.yml`

Once the config file is in place run `overcommit --sign`
to accept the config.