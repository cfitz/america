module America
  module Search
    
    class Spatial
      def initialize(&block)
         @value = {}
         block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end
       
      def state(state)
       @value[:state] = state
       self
      end 

      def to_ary
        [@value]
      end

      def to_json(options={})
        @value.to_json
      end

      def to_hash
        @value
      end

    end #class
    
  end
end
  