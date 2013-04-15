module Cleversafe
  class Connection
    attr_reader   :username
    attr_accessor :password
    attr_accessor :host
    attr_accessor :protocol

    def initialize(*args)
      if args[0].is_a?(Hash)
        options = args[0]
        @username = options[:username]
        @password = options[:password]
        @host = options[:host]
        @protocol = options[:protocol] || "http"
        @open_timeout = options[:open_timeout] || 10
      else
        @username = args[0]
        @password = args[1]
        @host = args[2]
        @protocol = args[3] || "http"
        @open_timeout = args[4] || 10
      end
    end

    def base_url
      "#{@protocol}://#{@host}/"
    end

    def url_for(vault, objectname, options={})
      protocol = options.fetch(:protocol, @protocol)
      host     = options.fetch(:host, @host)

      "#{protocol}://#{host}/#{vault}/#{objectname}"
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
      connection[path].get options
    end

    def head(path, options = {})
      connection[path].head options
    end

    def put(path, payload, options = {})
      connection[path].put payload, options
    end

    def delete(path)
      connection[path].delete
    end

    private
      def connection
        @connection ||= RestClient::Resource.new(base_url,
          :user         => username,
          :password     => password,
          :open_timeout => open_timeout,
          :raw_response => true
        )
      end
  end
end
