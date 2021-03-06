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

var UNDERSCORE = "./files/underscore-min.js";
var MOMENT = "./files/moment.min.js"
var JSON = "./files/input.json";
var JS = "./files/sample.js";

function benchmark(repeat, withIO) {
  var underscore = fs.readFileSync(UNDERSCORE);
  var moment = fs.readFileSync(MOMENT);
  var json = fs.readFileSync(JSON);
  var js = fs.readFileSync(JS);

  stopWatch.start();
  for (var i=0; i<repeat; i++) {
    var context = vm.createContext();
    var result;

    // underscore
    if (withIO) {
      vm.runInContext(fs.readFileSync(UNDERSCORE), context);
      vm.runInContext(fs.readFileSync(MOMENT), context);
      vm.runInContext('json='+fs.readFileSync(JSON), context);
      result = vm.runInContext(fs.readFileSync(JS), context);

    } else {
      vm.runInContext(underscore, context);
      vm.runInContext(moment, context);
      vm.runInContext('json='+json, context);
      result = vm.runInContext(js, context);
    }

    if (result!=1350) throw new Exception("Value is wrong!");
  }

  var elapsed = stopWatch.elapsed();
  var avg = elapsed / repeat;
  console.log("Done %d times: %d sec. avg: %d (IO=%s)", repeat, elapsed, avg, withIO);
}

benchmark(1000, true);
benchmark(1000, false);

