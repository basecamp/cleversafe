module Cleversafe
  class Vault
    
    attr_reader :name
    attr_reader :connection
    
    def initialize(connection, name)
      puts @connection
      @connection = connection
      @name = name
      
      self.vault_metadata
    end
    
    def vault_metadata
      response = @connection.get
      puts response
    end
  end
end