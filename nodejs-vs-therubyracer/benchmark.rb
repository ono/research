require 'v8'

class StopWatch
  def initialize
    @start = Time.now
  end

  def elapsed
    Time.now - @start
  end
end

UNDERSCORE = "./files/underscore-min.js"
JSON = "./files/input.json"
JS = "./files/sample.js"

def benchmark repeat, with_io
  _underscore = File.read UNDERSCORE
  _json = File.read JSON
  _js = File.read JS

  sw = StopWatch.new

  repeat.times do
    context = V8::Context.new

    # Loads underscore.js
    underscore = with_io ? File.read(UNDERSCORE) : _underscore
    context.eval(underscore)

    # Loads JSON
    json = with_io ? File.read(JSON) : _json
    context.eval('var json='+json)

    # Runs javascript
    js = with_io ? File.read(JS) : _js
    result = context.eval(js)

    raise "Value is wrong!" if result!=1350
  end

  puts "Done #{repeat} times: #{sw.elapsed} sec (IO=#{with_io})"
end

benchmark 10_000, true
benchmark 10_000, false

