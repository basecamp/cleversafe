require 'fileutils'

module Cleversafe
  class Object

    attr_reader :name
    attr_reader :vault

    def initialize(vault, objectname = {})
      @vault = vault.name
      @name = objectname
      @connection = vault.connection
    end

    def url(options={})
      @connection.url_for(@vault, @name, options)
    end

    def delete(objectname, options={})
      handle_errors do
        @connection.delete("#{@vault}/#{@name}", options)
      end
    end

    def exists?
      metadata
      true
    rescue Error::NotFound
      false
    end

    def data(options={})
      handle_errors do
        @connection.get("#{@vault}/#{@name}", options).to_s
      end
    end

    def open(options={})
      handle_errors do
        response = @connection.get("#{@vault}/#{@name}", options)
        begin
          yield response.file.open
        ensure
          response.file.close
        end
      end
    end

    def write_to(filename, options={})
      handle_errors do
        response = @connection.get("#{@vault}/#{@name}", options)
        FileUtils.mv(response.file.path, filename)
      end
    end

    def metadata
      @metadata ||= handle_errors { @connection.head("#{@vault}/#{@name}").headers }
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
    rescue RestClient::Exception => e
      if (e.http_code.to_s == "404")
        raise Error::NotFound, "object `#{@name}' does not exist", caller[0..-2]
      else
        raise
      end
    end
  end
end
