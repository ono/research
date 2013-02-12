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

class EmRacer
  include EM::Deferrable

  def run
    text = File.read("sample.json")
    hash = JSON.parse text

    @context = V8::Context.new
    @context["hash"] = hash
    @context["em"] = self

    @context.eval File.read("underscore.js")
    a = @context.eval "hash.foo8"
    raise "Wrong result" if a!="bar8"

    @context.eval "em.escape"
  end

  def escape
    self.succeed
  end
end

puts "memory start: #{memory}"

EM.run do
  30.times do |i|
    racer = EmRacer.new

    racer.callback do
      puts "memory #{i}: #{memory}"

      EM.stop if i==29
    end
    EM.next_tick { racer.run }
  end
end

puts "memory em end: #{memory}"


