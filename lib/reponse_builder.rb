# This class is responsible for contructing an HTTP reponse object
#
# @attr [Request] request Request object to create response for
# @attr [TCPSocket] session The session to create response for
# @attr [Router] router The Router object to look for matching routes in
class ResponseBuilder
    
    # Creates a new instance of ReponseBuilder
    #
    # @param [Request] request Request object to create response for
    # @param [TCPSocket] session The session to create response for
    # @param [Router] router The Router object to look for matching routes in
    def initialize(request, session, router)
        @request = request
        @session = session
        @router = router
    end
  
    # Build a reponse object 
    #
    # @return [Reponse] Built response object
    def build()
        response = Response.new(@session)

        if @request.is_static?
          build_static_response(response)
        else
          build_dynamic_response(response)
        end

        return response
    end

    private
    def build_static_response(response)
        resource = Resource.new(@request)
        if resource.data.nil?
          response.status_code = 404
          response.set_header('Content-Type', 'text/html')
          response.set_body("<h1>Error 404: File not found</h1>")
        else
          response.set_header('Content-Type', resource.type)
          response.set_body(resource.data)
        end
    end
  
    def build_dynamic_response(response)
        body = @router.route(@request)
        response.set_header('Content-Type', 'text/html')
        response.set_body(body)
    end
  end