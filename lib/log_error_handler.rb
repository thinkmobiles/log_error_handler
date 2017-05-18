require 'log_error_handler/version'
require 'tempfile'
require 'timerizer'
require_relative 'log_error_handler/log_file_tracker'
require_relative 'log_error_handler/stdin_reader'

module LogErrorHandler
  class Tracker
    attr_accessor :tracking_logs

    def initialize
      @tracking_logs = {}
    end

    def self.start
      tracker = new
      tracker.start
      tracker
    end

    def start
      @log_file_tracker = LogFileTracker.start(self)
      StdinReader.start(self)
    ensure
      close_all_files
    end

    private

    def close_all_files
      @log_file_tracker.thread.kill
      @tracking_logs.each do |_key, value|
        value[:file].rewind
        puts value[:file].read if value[:status] == :error
        value[:file].close
      end
    end
  end
end
