require 'v8'

class StopWatch
  def initialize
    @start = Time.now
  end

  def elapsed
    Time.now - @start
  end
end

REPEAT = 10_000
sw = StopWatch.new

REPEAT.times do
  context = V8::Context.new

  # Loads underscore.js
  #underscore = File.read "./files/underscore-min.js"
  underscore = File.read "./files/underscore.js"
  context.eval(underscore)

  # Loads JSON
  json = File.read "./files/input.json"
  context.eval('var json='+json)

  # Runs javascript
  js = File.read "./files/sample.js"
  result = context.eval(js)

  raise "Value is wrong!" if result!=1350
end

puts "Done #{REPEAT} times: #{sw.elapsed} sec"

