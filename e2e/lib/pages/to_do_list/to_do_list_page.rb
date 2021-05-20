class ToDoListPage < BasePage

  divs(:to_do_task_divs, class: 'list-group-item')

  def navigate_to_url(app_interface)
    @browser.goto(app_interface.eql?('API') ? 'https://aceraccoon-api-dev.azurewebsites.net/api/todo' : 'https://aceraccoonwebdev.z20.web.core.windows.net/')
  end

  def complete_task(task)
    task_id = JSON.parse(RestClient.get('https://aceraccoon-api-dev.azurewebsites.net/api/todo').body).values.first.find { |h| h['title'].eql?(task) }['id']
    RestClient.put("https://aceraccoon-api-dev.azurewebsites.net/api/todo/#{task_id}", nil)
  end

  def at_least_one_task?
    @browser.divs(class: 'list-group-item').count > 0
  end
end
