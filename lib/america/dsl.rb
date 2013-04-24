module America
  module DSL
    
    def configure(&block)
        Configuration.class_eval(&block)
    end

    def search(options={}, &block)
      if block_given?
        Search::Search.new(options, &block)
      else
        raise ArgumentError, "Please pass a Ruby Hash or an object with `to_hash` method, not #{params.class}" \
              unless options.respond_to?(:to_hash)
        Search::Search.new(options)
      end
    end
      
  end
end
