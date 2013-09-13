require 'fileutils'
require 'rack/utils'

module Cleversafe
  class Object

    attr_reader :vault, :key, :connection

    def initialize(vault, key)
      raise ArgumentError, "key is required" unless key =~ /\S/
      @vault = vault
      @key = key
      @connection = vault.connection
    end

    def path
      "#{vault.path}/#{Rack::Utils.escape_path key}"
    end

    def url
      connection.url_for(path)
    end

    def delete
      handle_errors do
        connection.delete(path)
      end
    end

    def exists?
      metadata
      true
    rescue Errors::NotFound
      false
    end

    def data(options = {})
      open(options) { |io| io.read }
    end

    def open(options = {})
      handle_errors do
        response = connection.get(path, options.merge(:raw_response => true))
        begin
          file = response.file
          file.open
          file.binmode
          yield file
        ensure
          file.unlink
        end
      end
    end

    def metadata
      @metadata ||= handle_errors do
        connection.head(path).headers
      end
    end

    def etag
      metadata[:etag]
    end

    def size
      metadata[:content_length].to_i
    end

    private
      def handle_errors
        yield
      rescue RestClient::ResourceNotFound
        raise Cleversafe::Errors::NotFound, "object `#{key}' does not exist", caller[0..-2]
      end
  end
end
