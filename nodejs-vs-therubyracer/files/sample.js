
var x3 = _(json).map(function(a) { return a["point"] * 3 });
var sum = _(x3).reduce(function(memo, num) { return memo + num}, 0);

sum

