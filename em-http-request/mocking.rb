require 'em-http-request'
require 'eventmachine'

require 'webmock'
require 'vcr'
include WebMock::API

# stub_request(:get, /.*/).
#   to_return(:status => 200, :body => "hoge")

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'vcr'
  c.ignore_localhost = false
end

# Can't put this inside em loop
VCR.use_cassette('em_http') do
  EventMachine.run do
    url = 'http://localhost:4567/hello'
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
      p http.response
      EM.stop
    end
  end
end

