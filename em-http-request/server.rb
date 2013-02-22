require 'sinatra'

get '/401' do
  status 401
  "401"
end

get '/hello' do
  "Hello world!"
end
