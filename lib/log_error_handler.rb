require_relative 'log_error_handler/version'
require 'tempfile'
require_relative 'log_error_handler/log_file_tracker'
require_relative 'log_error_handler/stdin_reader'
require_relative 'log_error_handler/http_out'
require_relative 'log_error_handler/out_factory'

module LogErrorHandler
  class Tracker
    attr_accessor :tracking_logs
    attr_reader :options, :out

    DEFAULT_OPTIONS = {
      error_regexp: /500.*error/i,
      tid_regexp: /^\[\d+\]/,
      not_modify_timeout: 3,
      log_file_tracker_waiting: 300,
      http_method: :post,
      key: :message
    }.freeze

    def initialize(opts = {})
      @tracking_logs = {}
      @options = DEFAULT_OPTIONS.merge(opts)
      @out = OutFactory.retrieve(@options)
    end

    def self.start(opts = {})
      tracker = new(opts)
      if opts[:log_file]
        IO.popen("tail -f #{opts[:log_file]}") do |stdin|
          $stdin = stdin
          tracker.start
        end
      else
        tracker.start
      end

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
        @tracker.out.puts value[:file].read if value[:status] == :error
        value[:file].close
        value[:file].unlink
        @out.close
      end
    end
  end
end
