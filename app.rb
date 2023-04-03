Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }

server = Server.new(4567)

server.get("/add/:num1/:num2") do |num1, num2|
    "<h1>#{num1} + #{num2} = #{num1.to_i+num2.to_i}</h1>"
end

server.get("/multiply/:num1/:num2") do |num1, num2|
    "<h1>#{num1} * #{num2} = #{num1.to_i*num2.to_i}</h1>"
end

server.start()