require 'sinatra'

get '/401' do
  status 401
  "401"
end
