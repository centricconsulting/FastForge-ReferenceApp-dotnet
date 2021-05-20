# frozen_string_literal: true

Before do |scenario|
  $world = self # for logging to cucumber json output.  $world.puts "text"

  STDOUT.puts "Scenario started at #{Time.now.strftime("%Y%m%d-%H%M%S")}"

  Helpers::Fixtures.load_fixtures_for(scenario)

  @browser = Helpers::Browser.create_browser(scenario)
  Helpers::Video.start_video(scenario, @browser.name, false)
end

After do |scenario|
  # Close Video
  Helpers::Video.end_video

  begin
    if scenario.failed?
      # Save screen shot
      time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
      FileUtils.mkdir_p Nenv.screenshot_path
      filename = "#{Nenv.screenshot_path}/error-#{@current_page.class}-#{time}.png"
      @current_page&.save_screenshot(filename)
      @current_page&.screenshot.save(filename)
      embed(filename, 'image/png')
      puts 'Data used via populate in this function'
      $world.puts DataForCache.instance.cache.to_s
    end
  rescue StandardError => ex
    STDERR.puts "Exception thrown while saving screenshot: #{ex}"
  end

  if Nenv.cuke_debug && scenario.failed?
    STDOUT.puts "Debugging scenario: #{scenario.title}"
    binding.pry; 2
  end

  Helpers::Browser.save_sauce_status(scenario, @browser) if Nenv.browser_type == :remote

  Cucumber.wants_to_quit = Nenv.fail_fast if scenario.failed?

  @browser&.close
end

Before('@wip or @ci') do
  # This will only run before scenarios tagged
  # with @wip OR @ci.
end

AfterStep('@wip or @ci') do
  # This will only run after steps within scenarios tagged
  # with @wip AND @ci.
end

# Pause after each N steps based on the setting
AfterStep do |scenario|
  next unless Nenv.cuke_step_size > 0 && Nenv.cuke_debug
  # TODO: This all needs reworked for Cuke 4
  # if scenario.class == Cucumber::Ast::OutlineTable::ExampleRow
  if scenario.class == Cucumber::Core::Ast::ExamplesTable::Row
    title = scenario.scenario_outline.title
    step_count = scenario.scenario_outline.raw_steps.count
  else
    title = scenario.title
    step_count = scenario.steps.count
  end

  unless defined?(@step_counter)
    STDOUT.puts "Stepping through #{title}"
    @step_counter = 0
  end

  @step_counter += 1

  STDOUT.puts "At step ##{@step_counter} of #{step_count}. Press Return to execute..."
  STDIN.getc
  STDOUT.puts 'Executing next step'
end
