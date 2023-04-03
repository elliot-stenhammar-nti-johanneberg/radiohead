require 'mime/types'

# This class represents a resource that can be requested through HTTP.
# It retrieves the data from the file system and sets the media type of the resource using MIME::Types.
class Resource
    attr_accessor :type, :data

    # Error when file is not found
    NO_FILE_ERROR = Errno::ENOENT.freeze
    # Error when the path points to a directory
    IS_A_DIRECTORY = Errno::EISDIR.freeze

    # Creates a new instance of a Resource
    #
    # @param request [Request] Request object to create resource for
    def initialize(request)
        file_path = "public" + request.resource
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
            file.close 
        rescue NO_FILE_ERROR, IS_A_DIRECTORY => err
            raise err
        end
    end
end