module Response

    def self.status_200(session, html)
        session.print "HTTP/1.1 200\r\n"
        session.print "Content-Type: text/html\r\n"
        session.print "\r\n"
        session.print html
        session.close 
    end

    def self.status_404(resource, session)
        session.print "HTTP/1.1 404\r\n"
        session.print "Content-Type: text/html\r\n"
        session.print "\r\n"
        session.print "<h1> error 404 </h1> \n<p> resource: \"#{resource}\" does not exist. </p>"
        session.close
    end

    def self.status_420(session)
        session.print "HTTP/1.1 420\r\n"
        session.print "Content-Type: text/html\r\n"
        session.print "\r\n"
        session.print "<p> Unable to display non HTML files. </p>"
        session.close
    end

end