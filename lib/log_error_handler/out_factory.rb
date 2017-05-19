module LogErrorHandler
  class OutFactory
    def self.retrieve(opts)
      if opts[:file]
        File.new(opts[:file], 'w')
      elsif opts[:url]
        HttpOut.new(opts)
      else
        $stdout
      end
    end
  end
end
