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
      @thread = Thread.new(&:log_file_tracker)
    end

    private

    def log_file_tracker
      loop do
        sleep 10
        @tracker.tracking_logs.each do |key, value|
          next if value[:timestamp] > 3.seconds.ago
          value[:file].rewind
          puts "#{value[:file].read}\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" if value[:status] == :error
          value[:file].close
          outs.delete(key)
        end
      end
    end
  end
end
