require 'rest_client'
require 'multi_json'
require 'hashr'
require 'cgi'


require 'active_support/core_ext/object/to_query'
require 'active_support/core_ext/hash/except'
require 'active_support/json'
require 'america/hash'


require "america/version"
require "america/configuration"
require "america/logger"

require "america/dsl"

require 'america/search/search'
require 'america/search/search_helper'

require 'america/search/query'
require 'america/search/sort'
require 'america/search/spatial'
require 'america/search/facet'


require 'america/results/pagination'
require 'america/results/collection'
require 'america/results/item'


require 'america/http/response'
require 'america/http/client'

require 'america/exceptions'

module America
  extend DSL
  
end
