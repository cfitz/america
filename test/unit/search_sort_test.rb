require 'test_helper'

module America::Search

  class SortTest < Test::Unit::TestCase

    context "Sort" do

      should "be serialized to JSON" do
        assert_respond_to Sort.new, :to_json
      end

      should "encode simple strings" do
        output = { :sort_by => [ :foo ] }
        assert_equal output.to_json, Sort.new.by(:foo).to_json
      end

     
      should "encode multiple sort fields in chain" do
        output = {:sort_by => [:foo, :bar]}.to_json
        assert_equal output, Sort.new.by(:foo).by(:bar).to_json
      end

      should "encode fields when passed as a block to constructor" do
        s = Sort.new do
          by :foo
          by :bar
          order :desc
        end
        output = { :sort_by => [:foo, :bar], :sort_order => :desc  }
        assert_equal output.to_json, s.to_json
      end


      should "encode fields deeper in json" do
        s = Sort.new { by 'sourceResource.title'; order :desc }
        output = { :sort_by => ['sourceResource.title' ], :sort_order => :desc }
        assert_equal output.to_json, s.to_json
          
        s = Sort.new { by 'sourceResource.date.begin' }
        output = { :sort_by => [ 'sourceResource.date.begin' ] }
        assert_equal output.to_json, s.to_json
      end
      
       should "encode sort_by_pin when passed as a block " do
          s = Sort.new do
            by_pin "41.3,-71"
          end
          output = { :sort_by_pin => "41.3,-71" }
          assert_equal  output.to_json, s.to_json
        end
      

    end

  end

end
