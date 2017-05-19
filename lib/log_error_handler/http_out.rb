module LogErrorHandler
  class HttpOut
    def initialize(opts)
      @options = opts
      @req = Net::HTTP.const_get(@options[:http_method].capitalize).new(@options[:uri])
    end

    def puts(message)
      data = @options[:additional_params] || {}
      data[@options[:error_message_key]] = message
      @req.set_form_data(data)
      Net::HTTP.new(@options[:uri].hostname, @options[:uri].port).request(@req)
    end

    def close
    end
  end
end
