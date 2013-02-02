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
Done 1000 times: 4.06176 sec. avg: 0.004061764 (IO=true)
Done 1000 times: 4.95496 sec. avg: 0.00495496 (IO=false)
```

**Node.js**

```
Done 1000 times: 3.834 sec. avg: 0.003834 (IO=true)
Done 1000 times: 3.565 sec. avg: 0.003565 (IO=false)
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

Well, that's what I thougt. However it turned out that the benchmark without IO is
slower than the one reading file everytime in Ruby...



