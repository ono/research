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

var UNDERSCORE = "./files/underscore-min.js";
var JSON = "./files/input.json";
var JS = "./files/sample.js";

function benchmark(repeat, withIO) {
  var _underscore = fs.readFileSync(UNDERSCORE);
  var _json = fs.readFileSync(JSON);
  var _js = fs.readFileSync(JS);

  stopWatch.start();
  for (var i=0; i<repeat; i++) {
    var context = vm.createContext();
    var underscore = withIO ? fs.readFileSync(UNDERSCORE) : _underscore;
    vm.runInContext(underscore, context);

    var json = withIO ? fs.readFileSync(JSON) : _json;
    vm.runInContext('json='+json, context);

    var js = withIO ? fs.readFileSync(JS) : _js;
    result = vm.runInContext(js, context);

    if (result!=1350) throw new Exception("Value is wrong!");
  }

  console.log("Done %d times: %d sec (IO=%s)", repeat, stopWatch.elapsed(), withIO);
}

benchmark(10000, true);
benchmark(10000, false);

