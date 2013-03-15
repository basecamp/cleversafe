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
    
    def data(options={})
      @connection.get("#{@vault}/#{@name}", options).to_s
    rescue RestClient::Exception => e
      if e.http_code.to_s == "404"
        raise "#{e.http_code.to_s}: Object #{@name} does not exist"
      else
        raise
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
