Feature: To-Do List Tests
  Scenario: To-Do List Test - Verify a task's status can be changed - API
    Given user connects to the to-do list API
    When user changes the status of Task Two
    Then user verifies that the task status is changed

  Scenario: To-Do List Test - Verify there is at least one task on the page - UI
    Given user connects to the to-do list UI
    Then user verifies that there is at least one task on the page
