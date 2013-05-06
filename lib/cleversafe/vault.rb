module Cleversafe
  class Vault
    attr_reader :connection, :name

    def initialize(connection, name)
      @connection = connection
      @name = name
    end

    def metadata
      @metadata ||= JSON.parse connection.get(name).to_s
    end

    def bytes_used
      metadata['vault_usage']['used_size']
    end

    def object(key)
      Cleversafe::Object.new(self, key)
    end
    alias [] object

    def objects(params = {})
      options = {}
      options['X-Operation'] = "list"
      options['X-List-Length-Limit'] = params[:limit] if params[:limit]
      options['X-Start-Id'] = params[:start_id] if params[:start_id]
      connection.get(name, options).to_s.split("\n")
    end

    def create_object(payload, options = {})
      response = connection.put(name, payload, options)
      id = response.to_s.strip

      if response.headers[:x_content_digest]
        { :id => id, :x_content_digest => response.headers[:x_content_digest] }
      else
        id
      end
    end
  end
end
