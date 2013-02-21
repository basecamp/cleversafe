module Cleversafe
  class Object
    
    attr_reader :name
    attr_reader :vault

    def initialize(vault, objectname = {})
      @vault = vault.name
      @name = objectname
      @connection = vault.connection
    end
    
    def data
      begin
        @connection.get("#{@vault}/#{@name}").body
      rescue => e
        raise "Object #{@name} does not exist"
      end
    end
    
    def object_metadata
      begin
        @object_metadata ||= @connection.head("#{@vault}/#{@name}").headers
      rescue => e
        raise "Object #{@name} does not exist"
      end
    end
    
    def etag
      self.object_metadata[:etag]
    end
    
    def write(payload, options = {})
      response = @connection.put("#{@vault}", payload, options)
      digest_header = "x_content_digest"
      if response.headers[:x_content_digest]
        {:id => response.body, :x_content_digest => response.headers[:x_content_digest] }
      else
        response.body
      end
    end
    
  end
end