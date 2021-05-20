### 1. Environment variables

The table below lists the various environment variables that can be used to tune the behavior of the framework.  Many of these are exposed as profiles. 
See [./docs/Running Framework.md](./docs/Running Framework.md) for more details

| Variable               | Allowed Values                    | Required                      | Default   | Info                                                         |
| ---------------------- | --------------------------------- | ----------------------------- | --------- | ------------------------------------------------------------ |
| TEST\_ENV              | Freeform                          |                               |           | Used to differentiate which environment you're running in.   |
| TEST\_ENV\_NUMBER      | Any integer                       |                               |           | Used for differentiating between children when running tests in parallel. |
| CUKE\_DEBUG            | true/false                        |                               | false     | If set to true, a pry session will be opened when a test fails. |
| CUKE\_ENV\_DEBUG       | true/false                        |                               | false     | If set to true, a pry session will be opened eat the end of env.rb |
| CUKE\_STEP\_SIZE       | Any integer                       |                               | 0         | If set to a non-zero value, test execution will stop and wait for a keypress.  Useful for doing demos. |
| FAIL\_FAST             | true/false                        |                               | false     | When true, stops cucumber after first failure, no other tests run |
| BROWSER\_TYPE          | local, remote                     |                               | local     | Set to local to use browsers via your local machine.   Set to remote to use browsers via sauce labs. |
| BROWSER                | chrome, firefox, ie, safari, edge |                               | chrome    | Set to the brand of browser you want to test under.          |
| BROWSER\_RESOLUTION    | NxN                               |                               | 1920x1080 | Used to specify a specific resolution for the browser window.  For example: 1024x768 |
| SAUCE\_VERSION         |                                   | When BROWSER\_TYPE == remote. |           | Specify sauce version to use. See (https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/) |
| SAUCE\_PLATFORM        |                                   | When BROWSER\_TYPE == remote. |           | Specify suace platform to use. See (https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/) |
| SAUCE\_CLIENT\_TIMEOUT | Any integer                       | When BROWSER\_TYPE == remote. | 180       | Used to set timeout for Sauce Lab connections                |
| SELENIUM\_HUB\_HOST    | domain or ip                      |                               | localhost | used to specify selenium grid host                           |
| SELENIUM\_HUB\_port    | port integer                      |                               | 8080      | used to specify selenium grid port                           |


### Profiles

The following table contains the available Cucumber profiles.

| Category      | Profile  | Purpose                                                      |
| ------------- | -------- | ------------------------------------------------------------ |
| __misc__      |          |                                                              |
|               | default  | Sets output to color, excludes the tags @wip and @broken and enables the following profiles: local, chrome, json |
|               | chaos    | Same as above except that it __includes__ @wip and @broken.  |
| __platforms__ |          |                                                              |
|               | desktop  | Sets BROWSER_RESOLUTION to 1920x1080 enables @any_resolution and @allow_desktop disables @no_desktop |
|               | mobile   | Sets BROWSER_RESOLUTION to 500x600 enables @any_resolution and @allow_mobile disables @no_mobile |
|               | tablet   | Sets BROWSER_RESOLUTION to 702x802 enables @any_resolution and @allow_tablet disables @no_tablet |
| __browsers__  |          |                                                              |
|               | local    | Sets BROWSER\_TYPE to local                                  |
|               | remote   | Sets BROWSER\_TYPE to remote                                 |
|               | chrome   | Sets BROWSER to chrome                                       |
|               | edge     | Sets BROWSER to edge                                         |
|               | firefox  | Sets BROWSER to firefox                                      |
|               | ie       | Sets BROWSER to ie                                           |
|               | safari   | Sets BROWSER to safari                                       |
| __output__    |          |                                                              |
|               | html     | Output results in html format as reports\test_TEST\_ENV\_NUMBER_.html |
|               | json     | Output results in json format as reports\test_TEST\_ENV\_NUMBER_.json |
|               | pretty   | Output results in human readable format.                     |
|               | rerun    | Create a cucumber rerun file as cucumber_failures_TEST\_ENV\_NUMBER_.log |
| __running__   |          |                                                              |
|               | parallel | Run tests in parallel.  May not work under Windows.          |
|               | slow_mo  | Sets CUKE\_STEP\_SIZE to 1                                   |
|               | debug    | Sets CUKE\_DEBUG to true                                     |



## Browser selection

For local browsers, browser selection is fairly easy.  Set BROWSER to any name supported by selenium webdriver.  Or use one of the profiles provided.

For remote browsers you'll need additional data / profiles...  #TODO

### Browser drivers

The folder [./config/webdrivers](./config/webdrivers) contains browser drivers.  These are downloaded and added to the suite path everytime you run via the webdrivers gem.  The default to check/download a driver is every 24 hours.