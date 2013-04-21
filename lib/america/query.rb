module America
  module Search

    class Query
      attr_accessor :value

      def initialize(&block)
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def source_resource(options={}, &block)
        @source_resource = SourceResourceQuery.new(options)
        block.arity < 1 ? @source_resource.instance_eval(&block) : block.call(@source_resource) if block_given?
        @value[:sourceResource] = @source_resource.to_hash
        @value
      end

      def term(field, value, options={})
        query = if value.is_a?(Hash)
          { field => value.to_hash }
        else
          { field => { :term => value }.update(options) }
        end
        @value = { :term => query }
      end

      def terms(field, value, options={})
        @value = { :terms => { field => value } }
        @value[:terms].update(options)
        @value
      end

      def range(field, value)
        @value = { :range => { field => value } }
      end

      def boolean(options={}, &block)
        @boolean ||= BooleanQuery.new(options)
        block.arity < 1 ? @boolean.instance_eval(&block) : block.call(@boolean) if block_given?
        @value[:bool] = @boolean.to_hash
        @value
      end

      def string(value, options={})
        value = value.join("+") if value.is_a?(Array)
        @value = { :q => value } 
        @value.update(options)
        @value
      end

      def to_hash
        @value
      end

      def to_json(options={})
        to_hash.to_json
      end

    end

    class BooleanQuery

      # TODO: Try to get rid of multiple `should`, `must`, etc invocations, and wrap queries directly:
      #
      #       boolean do
      #         should do
      #           string 'foo'
      #           string 'bar'
      #         end
      #       end
      #
      # Inherit from Query, implement `encode` method there, and overload it here, so it puts
      # queries in an Array instead of hash.

      def initialize(options={}, &block)
        @options = options
        @value   = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def must(&block)
        (@value[:must] ||= []) << Query.new(&block).to_hash
        @value
      end

      def must_not(&block)
        (@value[:must_not] ||= []) << Query.new(&block).to_hash
        @value
      end

      def should(&block)
        (@value[:should] ||= []) << Query.new(&block).to_hash
        @value
      end

      def to_hash
        @value.update(@options)
      end
    end

    class FilteredQuery
      def initialize(&block)
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def query(options={}, &block)
        @value[:query] = Query.new(&block).to_hash
        @value
      end

      def filter(type, *options)
        @value[:filter] ||= {}
        @value[:filter][:and] ||= []
        @value[:filter][:and] << Filter.new(type, *options).to_hash
        @value
      end

      def to_hash
        @value
      end

      def to_json(options={})
        to_hash.to_json
      end
    end


    class SourceResourceQuery
      
      def initialize(options= {}, &block)
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end
      
      def method_missing(method_name, *arguments, &block)
        @value[method_name] = arguments.join("+")
      end
      
      def to_hash
        @value
      end
      
     def date(options={}, &block)
        @date = DateQuery.new(options)
        block.arity < 1 ? @date.instance_eval(&block) : block.call(@date) if block_given?
        @value[:date] = @date.to_hash
        @value
    end
   
      
  end
    
  class DateQuery
    def initialize(options= {}, &block)
      @value = {}
      block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
    end
    
    def before(value)
      @value[:before] = value
    end
    
    def after(value)
      @value[:after] = value
    end
    
    def to_hash
        @value
    end
    
  end
   

  end
end
