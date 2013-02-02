var vm = require('vm'),
    fs = require('fs');

var stopWatch = {
  start: function() {
    this.startTime = new Date();
  },

  elapsed: function() {
    var now = new Date();

    return (now.getTime() - this.startTime.getTime()) / 1000.0;
  }
}
var repeat = 10000;

stopWatch.start();

for (var i=0; i<repeat; i++) {
  context = vm.createContext();

  var underscore = fs.readFileSync("./files/underscore-min.js");
  vm.runInContext(underscore, context);

  var json = fs.readFileSync("./files/input.json");
  vm.runInContext('var json='+json, context);

  var js = fs.readFileSync("./files/sample.js");
  result = vm.runInContext(js, context);

  if (result!=1350) throw new Exception("Value is wrong!");
}

console.log("Done %d times: %d sec", repeat, stopWatch.elapsed());

