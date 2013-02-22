module Cleversafe
  class Connection
    attr_reader   :username
    attr_accessor :password
    attr_accessor :host
    attr_accessor :proto
    attr_accessor :vault
    attr_accessor :method
    
    RestClient.log = "request.log"
    
    def initialize(*args)
      if args[0].is_a?(Hash)
        options = args[0]
        @username = options[:username]
        @password = options[:api_key]
        @host = options[:host]
        @protocol = options[:protocol] || "http"
      else
        @username = args[0]
        @password = args[1]
        @host = args[2]
        @protocol = args[3] || "http"
      end
      
      @connection ||= begin
        build_connection
      end
      return @connection
    end
    
    def build_connection
      RestClient::Resource.new(base_url, @username, @password)
    end
    
    def base_url
      "#{@protocol}://#{@host}/"
    end

    def vault(name)
      Cleversafe::Vault.new(self, name)
    end

    def vaults      
      vaults = JSON.parse(get(nil))['vaults']
      vaults.collect{|v| v['vault_name']}
    end
    
    def vault_exists?(vault_name)     
      begin
        response = get(vault_name)
        true
      rescue => e
        false
      end
    end
    
    def get(path, options = {})
      @connection[path].get options
    end
    
    def head(path, options = {})
      @connection[path].head options
    end
    
    def put(path, payload, options = {})
      @connection[path].put payload, options
    end
    
    def delete(path)
      @connection[path].delete
    end
    
  end
end