require 'json'
require 'forwardable'

module Cleversafe
  class Connection
    extend Forwardable

    def_delegators :@http, :url, :url_for, :get, :head, :put, :delete

    def initialize(url, options = {})
      @http = Cleversafe::HttpClient.new(url, options)
    end

    def vault(name)
      Cleversafe::Vault.new(self, name)
    end

    def vaults
      data = JSON.parse(get('/').to_s)
      data['vaults'].map { |v| v['vault_name'] }
    end

    def ping
      head '/'
      true
    rescue RestClient::Exception
      false
    end
  end
end
