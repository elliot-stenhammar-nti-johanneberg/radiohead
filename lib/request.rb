# This class represents an HTTP request
#
# @attr [Array] headers The HTTP request's headers
# @attr [String] verb The HTTP request's verb
# @attr [String] resource The HTTP requests's resource
# @attr [String] version The HTTP requests's version
class Request
    attr_reader :verb, :resource, :version

    # Creates a new instance of Request
    #
    # @param [String] data The raw HTTP request data
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
        @verb = request_line[0]
        @resource = request_line[1]
        @version = request_line[2]
    end
    
    # Checks if the request resource is a static file
    #
    # @return [Boolean] True if the resource is a static file, false otherwise
    def is_static?
        return @resource =~ /[.]/
    end

    # Dynamically retrieves a header by method name
    #
    # @param [Symbol] method The method name to retrieve the header for
    # @param [Array] args Optional arguments
    # @param [Proc] block Optional block
    # @return [String] The value of the requested header, or nil if not found
    def method_missing(method, *args, &block)
        header_key = method.to_s.gsub(/[_]/, '-').intern
        header = @headers[header_key]
        return header
    end

end