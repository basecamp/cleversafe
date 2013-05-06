require 'rest-client'
require 'json'

module Cleversafe
  class Connection
    def initialize(url, options = {})
      @http = build_http_client(url, options)
    end

    def url
      @http.url
    end

    def url_for(*paths)
      [ url, *paths ].join('/')
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
      @http[path].get options
    end

    def head(path, options = {})
      @http[path].head options
    end

    def put(path, payload, options = {})
      @http[path].put payload, options
    end

    def delete(path)
      @http[path].delete
    end

    private
      def build_http_client(url, options = {})
        defaults = { :open_timeout => 0.5 }
        RestClient::Resource.new(url, defaults.merge(options).merge(:raw_response => true))
      end
  end
end
