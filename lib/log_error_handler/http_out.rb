module LogErrorHandler
  class HttpOut
    def initialize(opts)
      @options = opts
      @req = Net::HTTP.const_get(@options[:http_method].capitalize).new(@options[:uri])
    end

    def puts(message)
      data = @options[:additional_params] || {}
      data[@options[:error_message_key]] = Base64.encode64(message)
      @req.set_form_data(data)
      http = Net::HTTP.new(@options[:uri].hostname, @options[:uri].port)
      http.use_ssl = @options[:uri].scheme == 'https'
      http.request(@req)
    end

    def close
    end
  end
end
