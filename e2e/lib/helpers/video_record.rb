# frozen_string_literal: true

# Helper modules should all live in the helper namespace.
# TODO: Test with headless
# For headless Might need to refer to https://stackoverflow.com/questions/55055694/ruby-capybara-recording-test-execution-videos
module Helpers
  module Video

    # Starts recording video
    # ffmpeg/bin must be in path on Windows
    # See https://kapoorlakshya.github.io/introducing-screen-recorder-ruby-gem
    # and https://github.com/kapoorlakshya/screen-recorder
    #
    # @param scenario [Cucumber:Scenario] The Cucumber scenario that is starting.
    # @param optional browser_brand [Object] Name of browser brand that we need to grab. ffmpeg needs to grab the process handle.
    # @param optional window [Boolean] True if you only want to capture the window, False for entire desktop (includes dual monitors)
    def self.start_video(scenario, browser_brand = nil, window = false)
      time = Time.now.strftime('%Y%m%d_%H%M%S')
      FileUtils.mkdir_p Nenv.video_path
      filename = "#{Nenv.video_path}/#{scenario.feature.name.gsub(/\s/, '-').downcase}-#{scenario.name.gsub(/\s/, '-').downcase}-#{time}.mp4"

      return unless Nenv.record_video?
      # advanced = {
      #     input:    {
      #         framerate:  30,
      #         pix_fmt:    'yuv420p',
      #         video_size: '1280x720'
      #     },
      #     output:   {
      #         r:       15, # Framerate
      #         pix_fmt: 'yuv420p'
      #     },
      #     log:      'recorder.log',
      #     loglevel: 'level+debug', # For FFmpeg
      # }
      #

      # Windowing is only supported on Windows
      if window && OS.windows? && !browser_brand.nil?
        window_title = ScreenRecorder::Titles.fetch(browser_brand).first
        @recorder = ScreenRecorder::Window.new(title: window_title, output: filename, advanced: {log: "#{Nenv.video_path}/recorder.log"})
      else
        @recorder = ScreenRecorder::Desktop.new(output: filename, advanced: {log: "#{Nenv.video_path}/recorder.log"})
      end

      # we don't want the rest of the suite to blow up because video fails.
      begin
        @recorder.start
      rescue StandardError => ex
        STDOUT.puts "Exception thrown while starting video #{ex}"
      end
    end

    def self.end_video
      return unless Nenv.record_video?

      # we don't want the rest of the suite to blow up because video fails.
      begin
        STDOUT.puts @recorder.options.output.to_s
        @recorder.stop
      rescue StandardError => ex
        STDOUT.puts "Exception thrown while stopping video #{ex}"
      end
    end
  end
end
