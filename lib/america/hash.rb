class Hash
  
  # for {"foo" => [] }.to_query we want just "foo"
  def to_query(namespace = nil)
      collect do |key, value|
          if (value.blank? )
              key
          else
              value.to_query(namespace ? "#{namespace}[#{key}]" : key)
          end
      end.sort * '&'
  end
  
  def to_facets_query
    output = self.inject([]) do |a, (k,v)| 
       str = "#{k}" 
       str << ":#{Array.wrap(v).join(",")}"  unless v.blank?
       a << str
    end
    { :facets => output }
  end
  
end