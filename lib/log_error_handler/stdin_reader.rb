module LogErrorHandler
  class StdinReader
    TMP_DIR_NAME = 'log_error_handler'.freeze

    def initialize(tracker)
      @tracker = tracker
    end

    def self.start(tracker)
      stdin_reader = new(tracker)
      stdin_reader.start
      stdin_reader
    end

    def start
      Dir.mkdir("/tmp/#{TMP_DIR_NAME}") unless Dir.exist?("/tmp/#{TMP_DIR_NAME}")
      $stdin.each do |line|
        tid = line[@tracker.options[:tid_regexp]]
        @last_tid = tid || @last_tid
        write_to_file(line) if @last_tid
      end
    end

    private

    def write_to_file(line)
      @tracker.mutex.lock
      @tracker.tracking_logs[@last_tid] ||= {
        file: Tempfile.new("log_error_handler/#{@last_tid}"),
        status: :ok,
        timestamp: Time.now.to_i
      }
      @tracker.mutex.unlock

      text = line.sub(@tracker.options[:tid_regexp], '')
      @tracker.tracking_logs[@last_tid][:file].write(text)
      @tracker.tracking_logs[@last_tid][:status] = :error if text[@tracker.options[:error_regexp]]
      @tracker.tracking_logs[@last_tid][:timestamp] = Time.now.to_i
    end
  end
end
