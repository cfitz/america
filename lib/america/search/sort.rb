module America
  module Search

    class Sort
      include SearchHelper

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
      
    end
  end
end
