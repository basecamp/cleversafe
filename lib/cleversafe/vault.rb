require 'cgi'

module Cleversafe
  class Vault
    attr_reader :connection, :name, :path

    def initialize(connection, name)
      @connection = connection
      @name = name
      @path = CGI.escape name
    end

    def metadata
      @metadata ||= JSON.parse(connection.get(path).to_s)
    end

    def usage
      metadata['vault_usage']
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

      connection.get(path, :headers => headers).to_s.split("\n")
    end

    def create_object(payload, options = {})
      handle_errors do
        response = connection.put(path, payload, options)
        id = response.to_s.strip

        if response.headers[:x_content_digest]
          { :id => id, :x_content_digest => response.headers[:x_content_digest] }
        else
          id
        end
      end
    end

    private
    def handle_errors
      yield
    rescue RestClient::MethodNotAllowed
      raise Cleversafe::Errors::VaultMisconfigured, "Vault has not been added to accessers.", caller[0..-2]
    end
  end
end
