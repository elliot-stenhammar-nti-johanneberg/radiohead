require 'socket'
require_relative 'lib/request_handler.rb'
require_relative 'lib/response.rb'

class HTTPServer
    NO_FILE_ERROR = Errno::ENOENT.freeze
    IS_A_DIRECTORY = Errno::EISDIR.freeze

    def initialize(port)
        @port = port
        @resource_directory = "html"
    end

    def start
        server = TCPServer.new(@port)
        puts "Listening on #{@port}"

        while session = server.accept
            data = ""

            while line = session.gets and line !~ /^\s*$/
                data += line
            end

            # parse http request
            request_handler = RequestHandler.new
            request = request_handler.parse(data)
            
            # access resource/file
            request_resource = request[:resource]
            resource_path = @resource_directory + request_resource

            begin # attempt to open file
                resource_file = File.open(resource_path, "r")
            rescue NO_FILE_ERROR, IS_A_DIRECTORY => e # error 404
                Response::status_404(request_resource, session)
                next
            end
            
            resource_plaintext = resource_file.read
            resource_file.close
            
            resource_extension = request_resource.split(".").last

            if resource_extension == "html"
                html = resource_plaintext
                Response::status_200(session, html)
            else
                Response::status_420(session)
            end
        end
    end
end

server = HTTPServer.new(4567)
server.start