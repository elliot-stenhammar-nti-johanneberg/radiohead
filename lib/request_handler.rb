class RequestHandler

    def parse(request)
        lines = request.split("\n")
        
        request_line = lines
            .first
            .split(" ")
        
        headers = lines
            .drop(1)
            .map{ |header| header.split(": ") }
            .to_h
        {
            verb: request_line[0],
            resource: request_line[1],
            version: request_line[2],
            headers: headers
        }
    end

end