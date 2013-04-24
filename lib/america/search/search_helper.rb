module America
  module Search
    module SearchHelper
    # welcome to namespace hell. 
    
      def initialize(&block)
         @value = {}
         block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def to_ary
        [@value]
      end

      def to_json
        @value.to_json
      end

      def to_hash
        @value
      end
    end
  end
end