module LogErrorHandler
  class StdinReader
    def initialize(tracker)
      @tracker = tracker
    end

    def self.start(tracker)
      stdin_reader = new(tracker)
      stdin_reader.start
      stdin_reader
    end

    def start
      $stdin.each do |line|
        tid = line[@tracker.options[:tid_regexp]]
        @last_tid = tid || @last_tid
        write_to_file(line) if @last_tid
      end
    end

    private

    def write_to_file(line)
      @tracker.tracking_logs[@last_tid] ||= {
        file: Tempfile.new("temps/#{@last_tid}"),
        status: :ok,
        timestamp: Time.now.to_i
      }
      text = line.sub(@tracker.options[:tid_regexp], '')
      @tracker.tracking_logs[@last_tid][:file].write(text)
      @tracker.tracking_logs[@last_tid][:status] = :error if text[@tracker.options[:error_regexp]]
      @tracker.tracking_logs[@last_tid][:timestamp] = Time.now.to_i
    end
  end
end
