module MobileHelper

  # These will need updated if the app IDs change, you can see the app Id in the Appium log
  # right after launching the app.  When adding a new app, the key should be the app name
  # found in Nenv.mobile_app_name
  APP_IDS = { marketing: 'com.servpro.workcenter.marketing.qa', drybook: 'com.servpro.drybook.v3.qa'  }

  def self.initialize_appium(global_driver=true)
    Appium::Driver.new(caps, global_driver)
  end

  def self.start_global_driver
    # rubocop:disable Style/GlobalVars
    $driver.start_driver unless $appium_driver_started
    $appium_driver_started = true
    # rubocop:enable Style/GlobalVars
  end

  def self.caps(opts = {})
    {
      caps: {
          platformName:    opts.fetch(:mobile_platform, Nenv.mobile_platform),
          platformVersion: opts.fetch(:mobile_version, Nenv.mobile_version),
          deviceName:      opts.fetch(:mobile_device, Nenv.mobile_device),
          app:             opts.fetch(:mobile_app_path, Nenv.mobile_app_path),
          automationName:  opts.fetch(:mobile_driver, Nenv.mobile_driver),
          newCommandTimeout: opts.fetch(:new_command_timeout, Nenv.new_command_timeout),
          noReset: !Nenv.reset_mobile?,
          forceMjsonwp: true,
          simpleIsVisibleCheck: false
      },
      appium_lib: {
          sauce_username:   nil, # don't run on Sauce
          sauce_access_key: nil,
          wait: Nenv.element_wait_time
      }
    }
  end

  def self.app_state(app_name=Nenv.mobile_app_name)
    begin
      $driver.app_state app_id(app_name)
    rescue Exception => e
      raise "Could not retrieve state for #{app_name} due to '#{e.message}'."
    end
  end

  def self.app_running_in_fg?(app_name=Nenv.mobile_app_name)
    self.app_state(app_name) == :running_in_foreground
  end

  def self.assert_app_running_in_fg(app_name=Nenv.mobile_app_name)
    raise "Expected #{app_name} to be running in the foreground but it has a state of #{self.app_state(app_name)}" unless self.app_running_in_fg?(app_name)
  end

  def self.app_id(app_name=Nenv.mobile_app_name)
    APP_IDS[app_name.downcase.to_sym]
  end

  def self.save_log(which)
    log_lines = $driver.get_log which
    return false if log_lines.empty?
    filename = "./logs/#{Nenv.mobile_app_name}-#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.#{which}.yml"
    File.open( filename, 'w' ) { |f| YAML.dump( log_lines, f ) }
    STDERR.puts "Saved #{which} log as #{filename}"
    true
  end

  def self.save_logs_if_needed
    return if self.app_running_in_fg?
    STDERR.puts 'Mobile app not running in foreground, dumping logs'
    save_log('crashlog')
    save_log('syslog')
  end

  def self.activate_app(app_name=Nenv.mobile_app_name)
    $driver.activate_app app_id(app_name)
    assert_app_running_in_fg(app_name)
  end
 end