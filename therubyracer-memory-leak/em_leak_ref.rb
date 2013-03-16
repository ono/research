require 'eventmachine'
require 'json'
require 'object_graph'

# Use Irwin's find-references version of Ruby to see more object reference
# information.
# http://cirw.in/blog/find-references

class EmLeak
  include EM::Deferrable

  def run
    @text = File.read("sample.json")
    @hash = JSON.parse @text

    self.succeed
    nil
  end

  def clear
    @hash = nil
    @text = nil
  end
end

require 'pp'

def inspect_refs
  refs = ObjectSpace.find_references(
      ObjectSpace.each_object(EmLeak).first
    )
  refs.each do |ref|
    puts "#{ref.class}: #{ref.inspect}"
    puts ref.methods.to_s
    puts ref.class.ancestors.to_s
  end
end

class Hoge
  def self.hoge_tick &block
    foo = []

    # if you use push instead of <<, memory doesn't leak.
    #foo.push(block)
    foo << block
    a = foo.shift
    a.call
  end
end

def first_tick
  leak = EmLeak.new

  leak.callback do
    puts "callback"

    # if you enabile below, reference will be freed
    #leak = nil
  end

  EM.next_tick { leak.run }

  # You can reproduce leak with hoge_tick
  # Hoge.hoge_tick { puts "test"; leak.run }
end

EM.run do
  first_tick
  EM.add_timer(1) do
    ObjectSpace.garbage_collect
    ObjectGraph.new(ObjectSpace.each_object(EmLeak).first).view!
    #inspect_refs
    EM.stop
  end
end

