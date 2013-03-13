require 'eventmachine'
require 'json'
require 'object_graph'

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

def inspect_refs refs
  refs.each do |ref|
    puts "#{ref.class}: #{ref.inspect}"
  end
end

def first_tick
  i = 0
  leak = EmLeak.new

  leak.callback do
    leak = nil if ARGV[0]
  end
  EM.next_tick { leak.run }
end

puts "Thread: #{Thread.current.inspect}"

EM.run do
  first_tick
  EM.next_tick do
    puts "Thread: #{Thread.current.inspect}"
    ObjectSpace.garbage_collect
    ObjectGraph.new(ObjectSpace.each_object(EmLeak).first).view!
    EM.stop
  end
end

#if ObjectSpace.each_object(Foo).first
#  refs = ObjectSpace.find_references(
#      ObjectSpace.each_object(Foo).first
#    )
#else
#  puts "Nothing"
#end


