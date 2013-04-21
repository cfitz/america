# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'america/version'

Gem::Specification.new do |spec|
  spec.name          = "america"
  spec.version       = America::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors       = ["chris fitzpatrick"]
  spec.email         = ["chrisfitzpat@gmail.com"]
  spec.summary   = "A Ruby client for DPLA API "
  spec.homepage      = "http://github.com/cfitz/america"
  spec.license       = "MIT"
  spec.rubyforge_project = "america"
  spec.files         = `git ls-files`.split($/)

  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  spec.require_paths = ["lib"]

  spec.extra_rdoc_files  = [ "README.md", "MIT-LICENSE" ]
  spec.rdoc_options      = [ "--charset=UTF-8" ]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_dependency "rake"
  spec.add_dependency "rest-client", "~> 1.6"
  spec.add_dependency "multi_json",  "~> 1.3"
  spec.add_dependency "hashr",       "~> 0.0.19"
  spec.add_dependency "activesupport"
  spec.add_dependency "ansi"
  
  # = Development dependencies
  spec.add_development_dependency "bundler",      "~> 1.0"
  spec.add_development_dependency "shoulda"
  spec.add_development_dependency "mocha",        "~> 0.13"
  spec.add_development_dependency "minitest",     "~> 2.12"
  spec.add_development_dependency "simplecov"
  
  unless defined?(JRUBY_VERSION)
    spec.add_development_dependency "yajl-ruby",   "~> 1.0"
    spec.add_development_dependency "bson_ext"
    spec.add_development_dependency "curb"
    spec.add_development_dependency "oj"
    spec.add_development_dependency "turn",        "~> 0.9"
  end
  
  
  
  spec.description = <<-DESC
    America is a ruby client for the Digital Public Library of America API. 
  DESC
  
  spec.post_install_message =<<-CHANGELOG.gsub(/^  /, '')
    ================================================================================

      Please check the documentation at Github

    --------------------------------------------------------------------------------

  #{America::CHANGELOG}
      See the full changelog at <http://github.com/cfitz/america/commits/v#{America::VERSION}>.

    --------------------------------------------------------------------------------
  CHANGELOG
  
end
