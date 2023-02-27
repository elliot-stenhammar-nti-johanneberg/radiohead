class Request
    attr_reader :verb, :resource, :version

    def initialize(data)
        lines = data.split("\r\n")
        
        request_line = lines
            .first
            .split(" ")
        
        @headers = lines
            .drop(1)
            .map{ |header| header.split(": ") }
            .to_h
            .transform_keys(&:to_sym)
        @method = request_line[0]
        @resource = request_line[1]
        @version = request_line[2]
    end

    def method_missing(method, *args, &block)
        header_key = method.to_s.gsub(/[_]/, '-').intern
        header = @headers[header_key]
        return header
    end

end