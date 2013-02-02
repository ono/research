## Node.js vs The Ruby Racer

Small project to take a benchmark between Node.js and The Ruby Racer.

## Objective

We are building a system which runs user javascript in sandbox.
We would like to know if node.js has an advantage to run a script in sandbox
in tems of performance.

## Install

You need:

* Node.js
* Ruby 1.9 + RubyGem + Bundler

Then run the following 

    Bundle install

## Run benchmark

**Ruby**

    bundle exec ruby benchmark.rb

**Node.js**

    node benchmark.js

## Result

**Ruby**

```
Done 1000 times: 3.451 sec. avg: 0.003451 (IO=true)
Done 1000 times: 3.825 sec. avg: 0.003825 (IO=false)
```

**Node.js**

```
Done 1000 times: 3.733 sec. avg: 0.003733 (IO=true)
Done 1000 times: 3.439 sec. avg: 0.003439 (IO=false)
```

**Environment**

Machine: Macbook Air.
CPU: 2GHz Intel Core i7
Ruby version: 1.9.3-p174
Node.js version: v0.8.4


## Note

**What does the benchmark do?**

* Load some libraries (underscore.js and moment.js)
* Load a JSON string
* Do map and reduce
* Repeat N times (1,000)

**What does IO=true/false mean?**

When IO=true, the text is loaded from file everytime in a loop.
When IO=false, the text is loaded from file at the beggininng so you can evaluate
it without IO costs.

Well, however the file reader is faster than cache with Ruby on this test.
It is interesting.

