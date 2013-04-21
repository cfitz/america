module America
  module Search

    class Sort
      def initialize(&block)
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def by(name)
        @value[:sort_by] ||= []
        @value[:sort_by] << name
        self
      end

      def order(direction)
        @value[:sort_order] = direction
        self
      end

     def by_pin(coord)
        @value[:sort_by_pin] = coord 
        self
      end

      def to_ary
        @value
      end

      def to_json(options={})
        @value.to_json
      end
      
      def to_hash
        @value
      end
      
    end

  end
end
