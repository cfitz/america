module America
  module Search
    class SearchRequestFailed < StandardError; end

    class Search

      attr_reader :query_type, :query, :facets, :filters, :options, :explain, :script_fields

      def initialize(query_type='items', options={}, &block)
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

      def url
        Configuration.url + @path
      end
      
      def api_key
        Configuration.api_key
      end

      def params
        options = @options.except(:wrapper, :payload)
        options.update( @query.to_hash ) if @query
        options.update( @sort.to_hash) if @sort
        options.empty? ? '' : '?' + url_encode(options) 
      end

      # this is hacky, but works with the to_param. We don't want `[]` or `]`, and `[` we want a `.`. And we want `,` unescaped.
      # this sucks. fix this.  
      def url_encode(options)
        params = options.to_param.gsub("%5B%5D", "").gsub("%5B", ".").gsub("%5D", "").gsub("%2C", ",")
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

      def facet(name, options={}, &block)
        @facets ||= {}
        @facets.update Facet.new(name, options, &block).to_hash
        self
      end

      def filter(type, *options)
        @filters ||= []
        @filters << Filter.new(type, *options).to_hash
        self
      end

     
      def from(value)
        @from = value
        @options[:from] = value
        self
      end

      def page_size(value)
        @page_size = value
        @options[:page_size] = value
        self
      end

      def perform    
        @response = Configuration.client.get(self.url + self.params)
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
        %Q|curl -X GET '#{url}#{params.empty? ? '?' : params.to_s + '&'}' -d '#{to_json_escaped}'|
      end


      # this is just here for debugging now. The DPLA api does not take GET payloads.
      def to_hash
          request = {}
          request.update( { :sort   => @sort.to_hash   } )    if @sort
          request.update( { :facets => @facets.to_hash } )   if @facets
          request.update( { :filter => @filters.first.to_hash } ) if @filters && @filters.size == 1
          request.update( { :filter => { :and => @filters.map {|filter| filter.to_hash} } } ) if  @filters && @filters.size > 1
          request.update( { :highlight => @highlight.to_hash } ) if @highlight
          request.update( { :page_size => @page_size } )               if @page_size
          request.update( { :from => @from } )               if @from
          request.update( { :fields => @fields } )           if @fields
          request.update( { :partial_fields => @partial_fields } ) if @partial_fields
          request.update( { :script_fields => @script_fields } ) if @script_fields
          request.update( { :version => @version } )         if @version
          request.update( { :explain => @explain } )         if @explain
          request.update( { :min_score => @min_score } )     if @min_score
          request.update( { :track_scores => @track_scores } ) if @track_scores
          request
      end

      def to_json(options={})
        payload = to_hash
        # TODO: Remove when deprecated interface is removed
        if payload.is_a?(String)
          payload
        else
          MultiJson.encode(payload, :pretty => Configuration.pretty)
        end
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
