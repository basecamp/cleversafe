module Cleversafe
  class HttpClient
    # Disable HTTP client timeouts by default. Older versions of RestClient
    # use a value of `-1` to disable timeouts; recent versions use `nil`.
    if RestClient.version < '1.6.9'
      DEFAULTS = { :timeout => -1, :open_timeout => -1 }
    else
      DEFAULTS = { :timeout => nil, :open_timeout => nil }
    end

    attr_reader :url

    def initialize(url, options = {})
      @url = url
      @defaults = DEFAULTS.merge(options)
    end

    def url_for(*path)
      File.join(url, *path)
    end

    def head(path, options = {})
      request :head, path, options
    end

    def get(path, options = {})
      request :get, path, options
    end

    def post(path, payload, options = {})
      request :post, path, options.merge(:payload => payload)
    end

    def put(path, payload, options = {})
      request :put, path, options.merge(:payload => payload)
    end

    def delete(path, options = {})
      request :delete, path, options
    end

    private
      def request(method, path, options = {})
        options = @defaults.merge(options).merge(:method => method, :url => url_for(path))
        RestClient::Request.execute(options)
      end
  end
end
