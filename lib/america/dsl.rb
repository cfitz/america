module America
  module DSL
    
    def configure(&block)
        Configuration.class_eval(&block)
    end

    def search(query_type ="items", options={}, &block)
      if block_given?
        Search::Search.new(query_type, options, &block)
      else
        raise ArgumentError, "Please pass a Ruby Hash or an object with `to_hash` method, not #{params.class}" \
              unless options.respond_to?(:to_hash)
        Search::Search.new(query_type, options)
      end
    end
      
      
    def count(indices=nil, options={}, &block)
      Search::Count.new(indices, options, &block).value
    end

    def index(name, &block)
      Index.new(name, &block)
    end

    def scan(names, options={}, &block)
      Search::Scan.new(names, options, &block)
    end

    def aliases
      Alias.all
    end

    
    
  end
end
