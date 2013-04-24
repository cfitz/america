<pre>
        .o.                                             o8o                      
       .888.                                            `"'                      
      .8"888.     ooo. .oo.  .oo.    .ooooo.  oooo d8b oooo   .ooooo.   .oooo.   
     .8' `888.    `888P"Y88bP"Y88b  d88' `88b `888""8P `888  d88' `"Y8 `P  )88b  
    .88ooo8888.    888   888   888  888ooo888  888      888  888        .oP"888  
   .8'     `888.   888   888   888  888    .o  888      888  888   .o8 d8(  888  
  o88o     o8888o o888o o888o o888o `Y8bod8P' d888b    o888o `Y8bod8P' `Y888""8o 
</pre>

"a work in progress...."
----------------------

This is an attempt at building a DSL in Ruby using the DPLA api. This is just a start. Maybe a bad, overly complicated idea, but 
I was wanting to get more practice at writing a DSL library...


## Installation
Now:
rake build
gem install pkg/america-0.0.1.gem

Eventually: 
Add this line to your application's Gemfile:

    gem 'america'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install america

## Usage

A search library for the dp.la api ( https://github.com/dpla/platform/ ). Also provides a basic DSL for searching, similar to the ElasticSearch Tire library. 

In order to access the API, you must have a DPLA api key. This can be set as ENV["DPL_API_KEY"] or America::Configuration.api_key("YOUR KEY HERE"). 

Basic queries can be done with: 
> America::Search::Search.new({ "sourceResource.description" => "perplexed" } ).perform
> search = America.search({ "sourceResource.description" => "perplexed" } )
> search.results # queries are lazy, so it does not execute until you ask...
which translate into: 
> 'http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY&sourceResource.description=perplexed'

Or use the DSL: 
<pre>
 American.new do
   query do
     string "a free text query"
     source_resource { description "perplexed"; title "fruit"; date { before("1963-11-30"); after("1963-11-01")  }; spatial { state("Oklahoma")}; }
   end
   sort do 
     by "sourceResource.spatial.coordinates"
     order :desc
     by_pin "41.3,-71"
   end
 end.perform
</pre>

which translate into: > 'http://api.dp.la/v2/items?api_key=MYDPLAAPIKEY&q=a+free+text+query&sourceResource.date.after=1963-11-01&sourceResource.date.before=1963-11-30&sourceResource.description=perplexed&sourceResource.title=fruit'


## To-Do

A bunch...

1. Increase the test coverage
2. Add/Improve spatial dsl
3. Facet queries
4. Passing Procs
5. Improve pagination
6. RDF.rb?



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
