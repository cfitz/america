module America
  module DSL
    
    def configure(&block)
        Configuration.class_eval(&block)
    end

    def search(options={}, query_type = "items",  &block)
      if block_given?
        Search::Search.new(options, query_type, &block)
      else
        raise ArgumentError, "Please pass a Ruby Hash or an object with `to_hash` method, not #{options.class}" unless options.respond_to?(:to_hash)
        Search::Search.new(options, query_type)
      end
    end
      
  end
end
