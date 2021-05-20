# Generic Tagging Guidelines

## General
* Tags should always be in lower case.  
* Tags should be placed on the line directly above the feature/scenario.
* Each scenario should be tagged with the test case number

## Common tags and their usage
| Tag           | Usage                                                                                                                                                        |
|---------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| @wip          | Used for scenarios that are works in progress and should not be included in a run                                                                            |
| @broken       | Used for scenarios that are broken and should not be included in a run.                                                                                      |
| @fixture_     | Used for loading fixtures with your scenario.  Anything after the fixture_ will be used as the filename.  e.g. @fixture_marketing_business                   |
| @test_case_   | Used for indicating the test case number, the scenario links back to. The test case number from Test Rail should follow e.g @test_case_7734                  |
| @bug_         | Used for indicating the scenario covers a bug in Jira.  The Jira ID of the bug should follow.  e.g. @bug_2252                                                |
| @appium       | Used to indicate a test that uses Appium.                                                                                                                    |
