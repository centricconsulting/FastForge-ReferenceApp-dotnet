# frozen_string_literal: true
# This will automatically check for driver version compatibility and download
# to designated folder for the suite to use.
# See https://github.com/titusfortner/webdrivers
require 'webdrivers'
require 'os'

module Centric
  module Drivers
    def self.make_driver_executable(file_path)
      return if OS.windows?
      File.chmod(0o0777, file_path) if File.exist?(file_path)
    end
  end
end

file_path = './config/webdrivers'

Webdrivers.cache_time = 86_400 # Default: 86,400 Seconds (24 hours)

Webdrivers.install_dir = file_path

Webdrivers.logger.level = :DEBUG

# Webdrivers.configure do |config|
#   config.proxy_addr = 'myproxy_address.com'
#   config.proxy_port = '8080'
#   config.proxy_user = 'username'
#   config.proxy_pass = 'password'
# end

# TODO: Validate the webdrivers gem needs permissions added.  Module may not be needed
