require 'mime/types'

class Resource
    attr_accessor :status, :type, :data

    NO_FILE_ERROR = Errno::ENOENT.freeze
    IS_A_DIRECTORY = Errno::EISDIR.freeze
    
    def initialize(resource)
        file_path = "resources" + resource
        @type = MIME::Types.type_for(file_path).first
        media_type = @type.media_type
        sub_type = @type.sub_type
        
        begin # attempt to open file
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
            @status = 404
        end
    end
end