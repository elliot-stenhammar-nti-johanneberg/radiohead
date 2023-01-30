class Response

    def initialize(resource)
        @status = resource.status
        case @status
        when 200
            @data = resource.data
            @content_type = resource.type 
        when 404
            @data = "<h1>Error 404: File not found</h1>"
            @content_type = "text/html" 
        end
    end

    def send(session)
        session.print "HTTP/1.1 #{@status}\r\n"
        session.print "Content-Type: #{@content_type}\r\n"
        session.print "Content-Length: #{@data.size}\r\n"
        session.print "\r\n"
        session.print @data
        session.close 
    end

end