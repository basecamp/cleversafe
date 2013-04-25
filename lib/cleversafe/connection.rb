require 'rest-client'
require 'json'

module Cleversafe
  class Connection
    attr_reader :protocol, :host, :username, :password, :open_timeout, :ssl_client_cert, :ssl_client_key, :ssl_ca_file, :verify_ssl

    def initialize(options = {})
      @protocol         = options.fetch(:protocol, "http")
      @host             = options.fetch(:host)
      @username         = options.fetch(:username, nil)
      @password         = options.fetch(:password, nil)
      @open_timeout     = options.fetch(:open_timeout, 10)
      @ssl_client_cert  = options.fetch(:ssl_client_cert, nil)
      @ssl_client_key   = options.fetch(:ssl_client_key, nil)
      @ssl_ca_file      = options.fetch(:ssl_ca_file, nil)
      @verify_ssl       = options.fetch(:verify_ssl, nil)
    end

    def base_url
      "#{protocol}://#{host}/"
    end

    def url_for(vault, objectname, options={})
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
      get(vault_name)
      true
    rescue RestClient::ResourceNotFound
      false
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
          :user             => username,
          :password         => password,
          :open_timeout     => open_timeout,
          :ssl_client_cert  => ssl_client_cert,
          :ssl_client_key   => ssl_client_key,
          :ssl_ca_file      => ssl_ca_file,
          :verify_ssl       => verify_ssl,
          :raw_response     => true
        )
      end
  end
end
