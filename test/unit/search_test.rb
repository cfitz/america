require 'test_helper'

module America

  class SearchTest < Test::Unit::TestCase

    context "Search" do
      setup { Configuration.reset }

    
      should "perform the search lazily" do
        response = mock_response '{"start":0,"docs":[]}', 200
        Configuration.client.expects(:get).returns(response)
        Results::Collection.expects(:new).returns([])

        s = Search::Search.new('items')
        assert_not_nil s.results
        assert_not_nil s.response
        assert_not_nil s.json
      end
      
      
      should "perform the search when passing params as a hash" do
        response = mock_response '{"start":0,"docs":[]}', 200
        Configuration.client.expects(:get).with do |url|
            url == 'http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY&sourceResource.description=perplexed'
        end.returns(response)
        Results::Collection.expects(:new).returns([])
        s = Search::Search.new('items',{ "sourceResource.description" => "perplexed" } ).perform
      end
      
      
      should "perform a query search when using the DSL" do
          response = mock_response '{"start":0,"docs":[]}', 200
          Configuration.client.expects(:get).with do |url|
              url == 'http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY&q=a+free+text+query&sort_by=sourceResource.spatial.coordinates&sort_by_pin=41.3,-71&sort_order=desc&sourceResource.date.after=1963-11-01&sourceResource.date.before=1963-11-30&sourceResource.description=perplexed&sourceResource.title=fruit'
          end.returns(response)
          Results::Collection.expects(:new).returns([])
          s = America::Search::Search.new() do
            query do
              string "a free text query"
              source_resource { description "perplexed"; title "fruit"; date { before("1963-11-30"); after("1963-11-01")  } }
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

        s = Search::Search.new('item')
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

        Search::Search.new('items').perform
      end

      should "log the original exception on failed request" do
        Configuration.logger STDERR

        Configuration.client.expects(:get).raises(Errno::ECONNREFUSED)
        Configuration.logger.expects(:log_response).with('N/A', '')

        assert_raise Errno::ECONNREFUSED do
          Search::Search.new('items').perform
        end
      end

      should "allow to set the server url" do
        search = Search::Search.new('items')
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
