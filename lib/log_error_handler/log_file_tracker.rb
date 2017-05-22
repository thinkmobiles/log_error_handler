module LogErrorHandler
  class LogFileTracker
    attr_reader :thread

    def initialize(tracker)
      @tracker = tracker
    end

    def self.start(tracker)
      log_file_tracker = new(tracker)
      log_file_tracker.start
      log_file_tracker
    end

    def start
      @thread = Thread.new { log_file_tracker }
    end

    private

    def log_file_tracker
      loop do
        sleep @tracker.options[:log_file_tracker_waiting]

        @tracker.mutex.lock
        @tracker.tracking_logs.each do |key, value|
          $stdout.puts "\n\nCheck file: #{key}. Status: #{value[:status]}\n\n" if @tracker.options[:debug_mode]
          next if Time.now.to_i - value[:timestamp] <= @tracker.options[:not_modify_timeout]
          if value[:status] == :error
            value[:file].rewind
            @tracker.out.puts value[:file].read
          end
          value[:file].close
          value[:file].unlink
          @tracker.tracking_logs.delete(key)
        end
        @tracker.mutex.unlock
      end
    end
  end
end
