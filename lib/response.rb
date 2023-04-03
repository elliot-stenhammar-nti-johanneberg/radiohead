# This class represents an HTTP response that can be sent to a client
class Response

    # Creates a new instance of Response
    #
    # @param [TCPSocket] session The TCP socket representing the client session
    # @param [Integer] status_code The HTTP status code to send
    # @param [Hash] headers A hash of HTTP headers to send
    # @param [String] body The response body to send 
    def initialize(session, status_code = 200, headers = {}, body = "")
      @session = session
      @status_code = status_code
      @headers = headers
      @body = body
    end

    # Sets a header in the response
    #
    # @param [String] name The name of the header to set
    # @param [String] value The value to set for the header
    def set_header(name, value)
      @headers[name] = value
    end

    # Sets the response body
    #
    # @param [String] body The response body to set
    def set_body(body)
      @body = body
    end

    # Sends the response to the client
    def send()
        @session.print "HTTP/1.1 #{@status_code}\r\n"
        unless @headers.empty?
          @headers.each do |name, value|
            @session.print "#{name}: #{value}\r\n"
          end
        end
        @session.print "\r\n"
        @session.print @body unless @body.empty?
        @session.close
    end
end