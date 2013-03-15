module Cleversafe
  class Vault
    
    attr_reader :name
    attr_reader :connection
    
    def initialize(connection, name)
      @connection = connection
      @name = name
    end
    
    def metadata
      @metadata ||= JSON.parse(@connection.get(@name))
    end
    
    def bytes_used
      metadata['vault_usage']['used_size']
    end
    
    def object(objectname)
      Cleversafe::Object.new(self, objectname)
    end
    
    def objects(params = {})
      options = {}
      options['X-Operation'] = "list"
      options['X-List-Length-Limit'] = params[:limit] if params[:limit]
      options['X-Start-Id'] = params[:start_id] if params[:start_id]     
      @connection.get(@name, options).split("\n")      
    end
    
    def object_exists?(objectname)
      begin
        response = @connection.head("#{@name}/#{objectname}")
        true
      rescue => e
        false
      end
    end
    
    def create_object(payload, options = {})
      response = @connection.put("#{@name}", payload, options)
      if response.headers[:x_content_digest]
        {:id => response.to_s, :x_content_digest => response.headers[:x_content_digest] }
      else
        response.to_s
      end
    end
    
    def delete_object(objectname)
      begin
        @connection.delete("#{@name}/#{objectname}")
      rescue RestClient::Exception => e
        raise "#{e.http_code.to_s}: Object #{objectname} does not exist" if (e.http_code.to_s == "404")
      end
    end
    
  end
end
