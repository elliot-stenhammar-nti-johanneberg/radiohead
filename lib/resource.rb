require 'mime/types'

class Resource
    attr_accessor :status, :type, :data

    NO_FILE_ERROR = Errno::ENOENT.freeze
    IS_A_DIRECTORY = Errno::EISDIR.freeze
    
    def initialize(request)
        file_path = "resources" + request.resource
        @type = MIME::Types.type_for(file_path).first
        @type == nil ? media_type = "text" : media_type = @type.media_type

        begin
            case media_type 
            when "text"
                file = File.open(file_path, "r")
            when "image", "application"
                file = File.open(file_path, "rb")
            end
            @data = file.read
            @status = 200
            file.close 
        rescue NO_FILE_ERROR, IS_A_DIRECTORY => e
            print(e)
            @status = 404
        end
    end
end