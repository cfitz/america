module America

  class Configuration

    def self.url(value=nil)
      @url = (value ? value.to_s.gsub(%r|/*$|, '') : nil) || @url || (  ENV["DPLA_API_URL"] ?  ENV["DPLA_API_URL"].gsub(%r|/*$|, '') : nil ) || "http://api.dp.la/v2"
    end

    def self.api_key(key=nil)
      @api_key = key || @api_key || ENV["DPLA_API_KEY"] || ( raise America::ParameterError, "DPLA API cannot be blank. Please set it by either America::Configuration.api_key() or ENV['DPLA_API_KEY']" )
    end

    # currently only supporting RestClient. Maybe add Curb or Faraday in future...
    def self.client(klass=nil)
      @client = klass || @client || HTTP::Client::RestClient
    end

    def self.wrapper(klass=nil)
      @wrapper = klass || @wrapper || Results::Item
    end

    def self.logger(device=nil, options={})
      return @logger = Logger.new(device, options) if device
      @logger || nil
    end

    def self.pretty(value=nil, options={})
      if value === false
        return @pretty = false
      else
        @pretty.nil? ? true : @pretty
      end
    end

    def self.reset(*properties)
      reset_variables = properties.empty? ? instance_variables : instance_variables.map { |p| p.to_s} & \
                                                                 properties.map         { |p| "@#{p}" }
      reset_variables.each { |v| instance_variable_set(v.to_sym, nil) }
    end

  end

end
