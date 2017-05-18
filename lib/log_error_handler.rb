require_relative 'log_error_handler/version'
require 'tempfile'
require_relative 'log_error_handler/log_file_tracker'
require_relative 'log_error_handler/stdin_reader'

module LogErrorHandler
  class Tracker
    attr_accessor :tracking_logs
    attr_reader :options

    DEFAULT_OPTIONS = {
      error_regexp: /500.*error/i,
      tid_regexp: /^\[\d+\]/,
      not_modify_timeout: 3,
      log_file_tracker_waiting: 300
    }.freeze

    def initialize(opts = {})
      @tracking_logs = {}
      @options = DEFAULT_OPTIONS.merge(opts)
    end

    def self.start(opts = {})
      tracker = new(opts)
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
