require 'fileutils'

module Cleversafe
  class Object

    attr_reader :connection, :vault, :name

    def initialize(vault, name)
      raise ArgumentError, "name is required" unless name =~ /\S/
      @connection = vault.connection
      @vault = vault.name
      @name = name
    end

    def key
      "#{vault}/#{name}"
    end

    def url(options={})
      connection.url_for(vault, name, options)
    end

    def delete
      handle_errors do
        connection.delete(key)
      end
    end

    def exists?
      metadata
      true
    rescue Errors::NotFound
      false
    end

    def data(options={})
      handle_errors do
        connection.get(key, options).to_s
      end
    end

    def open(options={})
      handle_errors do
        response = connection.get(key, options)
        begin
          yield response.file.open
        ensure
          response.file.unlink
        end
      end
    end

    def write_to(filename, options={})
      handle_errors do
        response = connection.get(key, options)
        FileUtils.cp(response.file.path, filename)
        FileUtils.rm(response.file.path)
      end
    end

    def metadata
      @metadata ||= handle_errors do
        connection.head(key).headers
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
      raise Cleversafe::Errors::NotFound, "object `#{name}' does not exist", caller[0..-2]
    end
  end
end
