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

    def objects(options = {})
      headers = {}

      headers['X-Operation'] = 'list'
      headers['X-Start-Id']  = options[:start_id] if options[:start_id]
      headers['X-List-Length-Limit'] = options[:limit] if options[:limit]

      connection.get(name, :headers => headers).to_s.split("\n")
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
