module Cleversafe
  class Object
    
    attr_reader :name
    attr_reader :vault

    def initialize(vault, objectname = {})
      @vault = vault.name
      @name = objectname
      @connection = vault.connection
    end
    
    def data(options ={})
      begin
        @connection.get("#{@vault}/#{@name}", options).body
      rescue RestClient::Exception => e
        raise "#{e.http_code.to_s}: Object #{@name} does not exist" if (e.http_code.to_s == "404")
      end
    end
    
    def object_metadata
      begin
        @object_metadata ||= @connection.head("#{@vault}/#{@name}").headers
      rescue RestClient::Exception => e
        raise "#{e.http_code.to_s}: Object #{@name} does not exist" if (e.http_code.to_s == "404")
      end
    end
    
    def etag
      self.object_metadata[:etag]
    end
    
  end
end