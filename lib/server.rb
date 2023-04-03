require 'socket'

# This class represents a HTTP server
class Server
    
    # Creates a new instance of Server
    #
    # @param [Integer] port The server port
    def initialize(port)
        @port = port
        @router = Router.new()
    end

    # Starts the server to listen for incoming connections
    def start()
        server = TCPServer.new(@port)

        while session = server.accept
            data = ""

            while line = session.gets and line !~ /^\s*$/
                data += line
            end

            request = Request.new(data)
            response = ResponseBuilder.new(request, session, @router).build()
            response.send()
        end
    end

    # Adds a new route to the server with the GET method
    #
    # @param [String] path The path for the route
    # @yield The block to be executed when the route is accessed
    def get(path, &block)
        @router.add_route("GET", path, &block)
    end

    # Adds a new route to the server with the POST method
    #
    # @param [String] path The path for the route
    # @yield The block to be executed when the route is accessed
    def post(path, &block)
        @router.add_route("POST", path, &block)
    end
end