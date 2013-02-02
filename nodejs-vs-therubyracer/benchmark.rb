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
MOMENT = "./files/moment.min.js"
JSON = "./files/input.json"
JS = "./files/sample.js"

def benchmark repeat, with_io
  underscore = File.read UNDERSCORE
  moment = File.read MOMENT
  json = File.read JSON
  js = File.read JS

  sw = StopWatch.new

  repeat.times do
    context = V8::Context.new

    # Loads underscore.js
    if with_io
      context.eval File.read(UNDERSCORE)
      context.eval File.read(MOMENT)
      context.eval 'var json='+File.read(JSON)
      result = context.eval File.read(JS)
    else
      context.eval underscore
      context.eval moment
      context.eval 'var json='+json
      result = context.eval js
    end

    raise "Value is wrong!" if result!=1350
  end

  elapsed = sw.elapsed
  avg = elapsed / repeat
  puts "Done #{repeat} times: #{elapsed} sec. avg: #{avg} (IO=#{with_io})"
end

benchmark 1_000, true
benchmark 1_000, false

