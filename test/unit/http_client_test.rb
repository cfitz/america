require 'test_helper'

module America
  module HTTP

    class ClientTest < Test::Unit::TestCase

      context "RestClient" do

        should "be default" do
          assert_equal Client::RestClient, Configuration.client
        end

        should "respond to HTTP methods" do
          assert_respond_to Client::RestClient, :get
          assert_respond_to Client::RestClient, :head
        end

        should "not rescue generic exceptions" do
          Client::RestClient.expects(:get).raises(RuntimeError, "Something bad happened in YOUR code")

          assert_raise(RuntimeError) do
            Client::RestClient.get 'http://example.com'
          end
        end

        should "not rescue ServerBrokeConnection errors" do
          Client::RestClient.expects(:get).raises(RestClient::ServerBrokeConnection)

          assert_raise(RestClient::ServerBrokeConnection) do
            Client::RestClient.get 'http://example.com'
          end
        end

        should "not rescue RequestTimeout errors" do
          Client::RestClient.expects(:get).raises(RestClient::RequestTimeout)

          assert_raise(RestClient::RequestTimeout) do
            Client::RestClient.get 'http://example.com'
          end
        end

      end

    end
  end

end
