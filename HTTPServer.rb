require 'socket'
require 'mime/types'
require_relative 'lib/request_handler.rb'
require_relative 'lib/resource.rb'
require_relative 'lib/response.rb'

class HTTPServer

    NO_FILE_ERROR = Errno::ENOENT.freeze
    IS_A_DIRECTORY = Errno::EISDIR.freeze

    def initialize(port)
        @port = port
        @resource_directory = "resources"
    end

    def start
        server = TCPServer.new(@port)

        while session = server.accept
            data = ""

            while line = session.gets and line !~ /^\s*$/
                data += line
            end

            request = RequestHandler.parse(data)
            resource = Resource.new(request[:resource])
            response = Response.new(resource)
            response.send(session)
        end
    end
end

server = HTTPServer.new(4567)
server.start