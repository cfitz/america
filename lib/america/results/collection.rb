module America
  module Results

    class Collection
      include Enumerable
      include Pagination

      attr_reader :total, :options, :facets

      def initialize(response, options={})
        @response  = response
        @options   = options
        @total     = response['count'].to_i rescue nil
        @facets    = response['facets']
        @wrapper   = options[:wrapper] || Configuration.wrapper
      end

      def results
        return [] if failure?
        @results ||= begin
            docs = @response["docs"]
            __get_results(docs)
        end
      end

      # Iterates over the `results` collection
      def each(&block)
        results.each(&block)
      end

      # This iteraters over the results and returns the result with
      # a "raw" hash that is the result from the DPLA api. 
      def each_with_hit(&block)
        results.zip(@response['docs']).each(&block)
      end

      def empty?
        results.empty?
      end

      def size
        results.size
      end
      alias :length :size

      def slice(*args)
        results.slice(*args)
      end
      alias :[] :slice

      def to_ary
        self
      end

      def as_json(options=nil)
        to_a.map { |item| item.as_json(options) }
      end

      def error
        @response['error']
      end

      def success?
        error.to_s.empty?
      end

      def failure?
        ! success?
      end

      def __get_results(docs)
        if @wrapper == Hash # just return a hash...
          docs
        else # wrap the results in a wrapper, like America::Results::Item
          docs.map { |doc|  @wrapper.new(doc) }
        end
      end

     

      def __find_records_by_ids(klass, ids)
        @options[:load] === true ? klass.find(ids) : klass.find(ids, @options[:load])
      end
    end

  end
end
