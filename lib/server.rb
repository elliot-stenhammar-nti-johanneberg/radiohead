require 'socket'
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }

class Server

    def initialize(port)
        @port = port
        @routes = {}
    end

    def start
        server = TCPServer.new(@port)

        while session = server.accept
            data = ""

            while line = session.gets and line !~ /^\s*$/
                data += line
            end

            request = Request.new(data)
            #CHECK ROUTES AND EXECUTE CODE...
            resource = Resource.new(request)
            response = Response.new(resource)
            response.send(session)
        end
    end

    def get(path, &block) 
         @routes[path] = {:code => @block} 
    end

    def post()

    end
end