require 'socket'
require 'mime/types'
require_relative 'lib/request_handler.rb'
require_relative 'lib/response.rb'

class HTTPServer
    NO_FILE_ERROR = Errno::ENOENT.freeze
    IS_A_DIRECTORY = Errno::EISDIR.freeze

    def initialize(port)
        @port = port
        @resource_directory = "html"
        
        reponse_info = { 
            :status => 0, 
            :data => ""
            :resource => ""
        }
    end

    def start
        server = TCPServer.new(@port)

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

            resource_type = MIME::Types.type_for(resource_path).first
            resource_media_type = resource_type.media_type
            resource_sub_type = resource_type.sub_type
            
            p resource_media_type

            begin # attempt to open file
                case resource_media_type 
                when "text"
                    resource_file = File.open(resource_path, "r")
                when "image", "application"
                    resource_file = File.open(resource_path, "rb")
                end
            rescue NO_FILE_ERROR, IS_A_DIRECTORY => e
                Response::status_404(request_resource, session)
                next
            end

            resource_plaintext = resource_file.read
            resource_file.close
            Response::status_200(session, resource_plaintext, resource_type)
        end
    end
end

server = HTTPServer.new(4567)
server.start