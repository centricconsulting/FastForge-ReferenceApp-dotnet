Given(/^user connects to the to\-do list (API|UI)$/) do |app_interface|
  on(ToDoListPage).navigate_to_url(app_interface)
end

When(/^user changes the status of (Task .*)$/) do |task|
  @response = on(ToDoListPage).complete_task(task)
end

Then(/^user verifies that there is at least one task on the page$/) do
  on(ToDoListPage).at_least_one_task?
end

Then(/^user verifies that the task status is changed$/) do
  expect(@response.code).to eq(204), "\nThe task status was not successfully changed.\n"
end
