require 'eventmachine'
require 'json'
require 'weakref'

def memory(process_id=Process.pid)
  rss = `ps -o rss= -p #{process_id}`.strip.to_i
  rss = rss / 1024
  vsz = `ps -o vsz= -p #{process_id}`.strip.to_i
  vsz = vsz / 1024

  "#{Time.now}: #{rss} MB (RSS) #{vsz} MB (VSZ)"
end

class EmLeak
  include EM::Deferrable

  def run
    @text = File.read("sample.json")
    @hash = JSON.parse @text

    self.succeed
  end

  def clear
    @hash = nil
    @text = nil
  end
end

puts "** EM memory leak sample"
puts "release mode is on (no leak)" if ARGV[0]

puts "memory start: #{memory}"

EM.run do
  30.times do |i|
    leak = EmLeak.new

    leak.callback do
      leak = nil if ARGV[0]
      puts "memory #{i}: #{memory}"

      EM.stop if i==29
    end
    EM.next_tick { leak.run }
  end
end

puts "memory em end: #{memory}"


