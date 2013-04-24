module America
  module Search

    class Facet

      def initialize(facet, values=[])
         @facet = facet
         @value = values.is_a?(Array) ? values : [values]
      end
          
        def to_hash
          { @facet => @value }
        end
   
     def to_ary
        [self.to_hash]
      end

      def to_json
        self.to_hash.to_json
      end
      
    end
  end
end
