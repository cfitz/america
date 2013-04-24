require 'test_helper'

module America::Search

  class FacetTest < Test::Unit::TestCase
    
    context "Facet" do
     
      should "be serialized to JSON" do
          assert_respond_to Facet.new("foo"), :to_json
      end
      
      should "build a hash with values" do
        facet = Facet.new("foo", ["one", "two"])
        assert_equal facet.to_hash, { "foo" => ["one", "two"]}
      end
      
      should "build a hash even if no values given" do
        facet = Facet.new("foo")
        assert_equal facet.to_hash, { "foo" => []}
      end
      
    end 
    
  end
end
    