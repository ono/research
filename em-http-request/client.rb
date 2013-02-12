require 'em-http-request'
require 'eventmachine'

EventMachine.run do
  #url = 'http://localhost:4567/401'
  url = 'http://localhost:98654/invalid'
  http = EventMachine::HttpRequest.new(url).get

  http.errback do |a|
    p "errback #{a}"
    p "#{a==http}"
    EM.stop
  end

  http.callback do |a|
    p "callback #{a}"
    p "#{a==http}"

    p http.response_header.inspect
    p http.response_header.http_status
    EM.stop
  end
end


