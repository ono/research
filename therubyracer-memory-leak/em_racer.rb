require 'json'
require 'v8'
require 'eventmachine'
require 'weakref'

def memory(process_id=Process.pid)
  rss = `ps -o rss= -p #{process_id}`.strip.to_i
  rss = rss / 1024
  vsz = `ps -o vsz= -p #{process_id}`.strip.to_i
  vsz = vsz / 1024

  "#{Time.now}: #{rss} MB (RSS) #{vsz} MB (VSZ)"
end

class EmRacer
  include EM::Deferrable

  def run
    @text = File.read("sample.json")
    @hash = JSON.parse @text

    escape

    # @context = V8::Context.new
    # @context["hash"] = hash
    # @context["em"] = self

    # @context.eval File.read("underscore.js")
    # a = @context.eval "hash.foo8"
    # raise "Wrong result" if a!="bar8"

    # @context.eval "em.escape"
    # @context = nil
  end

  def escape
    self.succeed
  end

  def clear
    @hash = nil
    @text = nil
  end
end

puts "memory start: #{memory}"

EM.run do
  30.times do |i|
    racer = EmRacer.new

    racer.callback do
      #WeakRef.new(racer)
      #racer.clear
      puts "memory #{i}: #{memory}"

      EM.stop if i==29
    end
    EM.next_tick { racer.run }
  end
end

puts "memory em end: #{memory}"


