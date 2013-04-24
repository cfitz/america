ENV['DEBUG'] = 'true'
ENV["DPLA_API_KEY"] = "MYDPLAAPIKEY"

require 'rubygems'
require 'bundler/setup'

require 'simplecov'
SimpleCov.start

require 'pathname'
require 'test/unit'



require 'shoulda'
require 'turn/autorun' unless ENV["TM_FILEPATH"]
require 'mocha/setup'


require 'america'

class Test::Unit::TestCase

  def assert_block(message=nil)
    raise Test::Unit::AssertionFailedError.new(message.to_s) if (! yield)
    return true
  end if defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

  def mock_response(body= '{"start":0,"docs":[]}', code=200, headers={})
    America::HTTP::Response.new(body, code, headers)
  end

  def fixtures_path
    Pathname( File.expand_path( 'fixtures', File.dirname(__FILE__) ) )
  end

  def fixture_file(path)
    File.read File.expand_path( path, fixtures_path )
  end

end


