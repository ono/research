require 'v8'

cxt = V8::Context.new
puts cxt.eval('7*6').to_s
