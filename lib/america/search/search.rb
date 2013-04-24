module America
  module Search
    
    class SearchRequestFailed < StandardError; end

    class Search

      attr_reader :query_type, :query, :facets, :fields, :options, :filters

      def initialize(options={}, query_type = "items",  &block)
        @query_type = query_type
        @options = options
        @options[:api_key]  ||= api_key
        @path    = "/#{ @query_type }"

        block.arity < 1 ? instance_eval(&block) : block.call(self) if block_given?
      end
      
       
      def results
        @results  || (perform; @results)
      end

      def response
        @response || (perform; @response)
      end

      def json
        @json   || (perform; @json)
      end

      def base_url
        Configuration.url + @path
      end

      def url
        self.base_url + self.params
      end
      
      def api_key
        Configuration.api_key
      end

      def params
        options = @options
        options.update( @query.to_hash ) if @query
        options.update( @sort.to_hash) if @sort
        options.update( @facets.to_facets_query ) if @facets
        options.empty? ? '' : '?' + url_encode(options) 
      end

      # this is hacky, but works with the to_param. We don't want `[]` or `]`, and `[` we want a `.`. And we want `,` unescaped.
      # this sucks. fix this.  
      def url_encode(options)
        params = options.to_query.gsub("%5B%5D", "").gsub("%5B", ".").gsub("%5D", "").gsub("%2C", ",")
      end

      def query(&block)
        @query = Query.new
        block.arity < 1 ? @query.instance_eval(&block) : block.call(@query)
        self
      end

      def sort(&block)
        @sort = Sort.new(&block).to_hash
        self
      end

      def facet(name, values=[])
        @facets ||= {}
        @facets.update Facet.new(name, values).to_hash
        self
      end

      def page(value)
        @page = value
        @options[:page] = value
        self
      end

      def page_size(value)
        @page_size = value
        @options[:page_size] = value
        self
      end
      
      def perform    
        @response = Configuration.client.get(self.url)
        if @response.failure?
          STDERR.puts "[REQUEST FAILED] #{self.to_curl}\n"
          raise SearchRequestFailed, @response.to_s
        end
        @json     = MultiJson.decode(@response.body)
        @results  = Results::Collection.new(@json, @options)
        return self
      ensure
        logged
      end

      def to_curl
        to_json_escaped = to_json.gsub("'",'\u0027')
        %Q|curl -X GET '#{base_url}#{params.empty? ? '?' : params.to_s + '&'}'|
      end



      def to_hash
          request = {}
          request.update({ :query_type => @query_type})       if @query_type
          request.update( { :sort   => @sort.to_hash   } )    if @sort
          request.update( { :facets => @facets.to_hash } )    if @facets
          request.update( { :page_size => @page_size } )      if @page_size
          request.update( { :page => @page } )                if @page
          request.update( { :fields => @fields } )            if @fields
          request.update( { :query => @query })               if @query
          request
      end

      def to_json(options={})
          MultiJson.encode(to_hash, :pretty => Configuration.pretty)
      end

      def logged(endpoint='items')
        if Configuration.logger

          Configuration.logger.log_request endpoint, to_curl
          code = @response.code rescue nil

          if Configuration.logger.level.to_s == 'debug'
            body = if @json
              MultiJson.encode( @json, :pretty => Configuration.pretty)
            else
              MultiJson.encode( MultiJson.load(@response.body), :pretty => Configuration.pretty) rescue ''
            end
          else
            body = ''
          end

          Configuration.logger.log_response code || 'N/A', body || 'N/A'
        end
      end

    end

  end
end
