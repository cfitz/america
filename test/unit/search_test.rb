require 'test_helper'

module America

  class SearchTest < Test::Unit::TestCase

    context "Search" do
      setup { Configuration.reset }

    
      should "perform the search lazily" do
        response = mock_response '{"start":0,"docs":[]}', 200
        Configuration.client.expects(:get).returns(response)
        Results::Collection.expects(:new).returns([])

        s = Search::Search.new()
        assert_not_nil s.results
        assert_not_nil s.response
        assert_not_nil s.json
      end
      
      
      should "perform the search when passing params as a hash" do
        response = mock_response '{"start":0,"docs":[]}', 200
        
        query = { "sourceResource.description" => "perplexed", :q => "a+free+text+query" }
        Configuration.client.expects(:get).with do |url|
            url.include? 'http://api.dp.la/v2/items'
            url.include? '?api_key=MYDPLAAPIKEY'
            url.include? '&sourceResource.description=perplexed'
        end.returns(response)
        Results::Collection.expects(:new).returns([])
        s = America.search( query ).perform
      end
      
      
      should "perform a query search when using the DSL" do
          response = mock_response '{"start":0,"docs":[]}', 200
          Configuration.client.expects(:get).with do |url|
              url.include? 'http://api.dp.la/v2/items?'
              url.include? 'api_key=MYDPLAAPIKEY'
              url.include? '&q=a+free+text+query'
              url.include? '&sort_by=sourceResource.spatial.coordinates'
              url.include? '&sort_by_pin=41.3,-71'
              url.include? '&sort_order=desc&sourceResource.date.after=1963-11-01'
              url.include? '&sourceResource.date.before=1963-11-30'
              url.include? '&sourceResource.description=perplexed'
              url.include? '&sourceResource.spatial.state=Massachusetts'
              url.include? '&sourceResource.title=fruit'
          end.returns(response)
          Results::Collection.expects(:new).returns([])
          s = America.search do
            query do
              string "a free text query"
              source_resource { description "perplexed"; title bool_and ["fruit", "nuts"]; date { before("1963-11-30"); after("1963-11-01")  }; spatial { state("Massachusetts")  }; }
            end
            sort do 
              by "sourceResource.spatial.coordinates"
              order :desc
              by_pin "41.3,-71"
            end
          end.perform
      end


      should "print debugging information on exception and return false" do
        ::RestClient::Request.any_instance.
                              expects(:execute).
                              raises(::RestClient::InternalServerError)
        STDERR.expects(:puts)

        s = Search::Search.new()
        assert_raise Search::SearchRequestFailed do
          s.perform
        end
      end

      should "log request, but not response, when logger is set" do
        Configuration.logger STDERR

        Configuration.client.expects(:get).returns(mock_response( '{"start":0,"docs":[]}', 200 ))

        Results::Collection.expects(:new).returns([])
        Configuration.logger.expects(:log_request).returns(true)
        Configuration.logger.expects(:log_response).with(200, '')

        Search::Search.new().perform
      end

      should "log the original exception on failed request" do
        Configuration.logger STDERR

        Configuration.client.expects(:get).raises(Errno::ECONNREFUSED)
        Configuration.logger.expects(:log_response).with('N/A', '')

        assert_raise Errno::ECONNREFUSED do
          Search::Search.new().perform
        end
      end

      should "allow to set the server url" do
        search = Search::Search.new()
        Configuration.url 'http://api.dp.la/v2'

        Configuration.client.
          expects(:get).
            with do |url|
              url == 'http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY'
            end.
          returns(mock_response( '{"start":0,"docs":[]}', 200 ))

        search.perform
      end

  
    end
  end

end
