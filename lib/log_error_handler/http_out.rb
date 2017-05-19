module LogErrorHandler
  class HttpOut
    def initialize(opts)
      @options = opts
      @req = "Net::HTTP::#{@options[:http_method].capitalize}".constantize.new(@options[:uri])
    end

    def puts(message)
      @req.set_form_data(@options[:key] => message)
      Net::HTTP.new(@options[:uri].hostname, @options[:uri].port).request(@req)
    end

    def close
    end
  end
end
