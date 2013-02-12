require 'json'
require 'v8'
require 'eventmachine'

def memory
  rss = `ps -o rss= -p #{Process.pid}`.strip.to_i
  rss = rss / 1024
  vsz = `ps -o vsz= -p #{Process.pid}`.strip.to_i
  vsz = vsz / 1024

  "#{rss} MB (RSS) #{vsz} MB (VSZ)"
end

def simple_racer(dispose=true)
  text = File.read("sample.json")
  hash = JSON.parse text

  context = V8::Context.new
  context["hash"] = hash

  context.eval File.read("underscore.js")
  a = context.eval "hash.foo8"
  raise "Wrong result" if a!="bar8"

  context.dispose if dispose
end

30.times do |i|
  puts "memory #{i}: #{memory}"

  simple_racer true
end

