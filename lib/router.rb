# This class represents a router for handling HTTP requests
class Router
    
    # Creates a new instance of Router
    def initialize()
        @routes = Hash.new { |hash, key| hash[key] = [] }
    end

    # Adds a new route to the router
    #
    # @param [String] verb The HTTP verb for the route (e.g. "GET", "POST")
    # @param [String] path The URL path for the route, which can include named parameters (e.g. "/users/:id")
    # @param [Proc] block The action to perform when the route is matched, which should take in any named parameters as arguments
    def add_route(verb, path, &block)
        regex = Regexp.new("^#{path.gsub(/:\w+/, '(\w+)')}$")
        @routes[verb].push({
            path: path,
            action: ->(request) do
                params = request.resource.match(regex).captures
                block.call(*params)
            end 
        })
    end

    # Finds a matching route for the given request and executes its action
    #
    # @param [Request] request The HTTP request to match against
    # @return The result of the matched route's action, or nil if no route is found
    def route(request)
        @routes[request.verb].each do |route|
            if Regexp.new("^#{route[:path].gsub(/:[^\/]+/, '([^\/]+)')}$").match(request.resource)
                return route[:action].call(request)
            end
        end
        return nil
    end
end