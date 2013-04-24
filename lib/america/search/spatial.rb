module America
  module Search
    
    class Spatial
      include SearchHelper
      
      
      def method_missing(method_name, *arguments, &block)
        @value[method_name] = arguments.join("+")
      end
      
    end #class
    
  end
end
  