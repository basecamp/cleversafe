module Cleversafe
  class Vault
    
    attr_reader :name
    attr_reader :connection
    
    def initialize(connection, name)
      @connection = connection
      @name = name
    end
    
    def vault_metadata
      JSON.parse(@connection.get(@name))
    end
    
    def bytes_used
      self.vault_metadata['vault_usage']['used_size']
    end
    
    def objects(params = {})
      options = {}
      options['X-Operation'] = "list"
      options['X-List-Length-Limit'] = params[:limit] if params[:limit]
      options['X-Start-Id'] = params[:start_id] if params[:start_id]      
      @connection.get(@name, options)
    end
  end
end