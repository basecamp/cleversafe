require 'json'
require 'forwardable'

module Cleversafe
  class Connection
    extend Forwardable

    def_delegators :@http, :url, :url_for, :get, :head, :put, :delete

    def initialize(url, options = {})
      @http = Cleversafe::HttpClient.new(url, options)
    end

    def ping
      head '/'
      true
    rescue Exception
      false
    end

    def status
      JSON.parse(get('/').to_s)
    end

    def vaults
      status['vaults'].map { |v| v['vault_name'] }
    end

    def vault(name)
      Cleversafe::Vault.new(self, name)
    end
  end
end
