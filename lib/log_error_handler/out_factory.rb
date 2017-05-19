module LogErrorHandler
  class OutFactory
    def self.retrieve(opts)
      if opts[:file]
        File.new(opts[:file], 'w')
      elsif opts[:uri]
        HttpOut.new(opts)
      else
        $stdout
      end
    end
  end
end
