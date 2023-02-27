Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }

server = Server.new(4567)

server.get("/test-route/:id") do |id|
    
end

server.start
