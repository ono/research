## Background

We have experienced some memory leak with the ruby racer.
I am trying to find out what causes the memory leak with simple example here.

## Test with a simple sample

Tested with simple\_racer method in simple\_racer.rb

It doesn't leak memory. RSS stops at certain point.
Interestingly there is no significant difference even if you don't call
V8::Context#dispose.



