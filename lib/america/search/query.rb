module America
  module Search

    class Query
      include SearchHelper
      attr_accessor :value

      
      def source_resource(&block)
        @source_resource = SourceResourceQuery.new
        block.arity < 1 ? @source_resource.instance_eval(&block) : block.call(@source_resource) if block_given?
        @value[:sourceResource] = @source_resource.to_hash
        @value
      end

    
      def keyword(value)
        value = value.join("+") if value.is_a?(Array)
        @value = { :q => value } 
        @value
      end

    end #Query

    class SourceResourceQuery
      include SearchHelper
    
      
      def method_missing(method_name, *arguments, &block)
        @value[method_name] = arguments.join("+")
      end
      
      def bool_and(args)
        args.join("+AND+")
      end
      
      def bool_or(args)
        args.join("+OR+")
      end
   
      def date(&block)
        @date = DateQuery.new
        block.arity < 1 ? @date.instance_eval(&block) : block.call(@date) if block_given?
        @value[:date] = @date.to_hash
        @value
      end
    
      def spatial( &block)
        @spatial = Spatial.new( &block)
        block.arity < 1 ? @spatial.instance_eval(&block) : block.call(@spatial) if block_given?
        @value[:spatial] = @spatial.to_hash
        @value
      end
   
      
    end #SourceResource
    
  class DateQuery
    include SearchHelper
    
    
    def before(value)
      @value[:before] = value
    end
    
    def after(value)
      @value[:after] = value
    end
    
    
  end #Date
   

  end
end
