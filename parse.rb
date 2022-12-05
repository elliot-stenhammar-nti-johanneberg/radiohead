require 'pp'

request_string = <<~END
    GET /hello HTTP/1.1
    User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
    Host: www.tutorialspoint.com
    Accept-Language: en-us
    Accept-Encoding: gzip, deflate
    Connection: Keep-Alive
END

def parse_request(request_string)
    status_line = request_string
        .split("\n")
        .first
        .split(" ")
    headers = request_string
        .split("\n")
        .drop(1)
        .map{ |header|
            header.split(":")}
    parsed_request = {
        verb: status_line.first,
        resource: status_line[1],
        headers: headers.to_h
    }
    return parsed_request
end

pp parse_request(request_string)
