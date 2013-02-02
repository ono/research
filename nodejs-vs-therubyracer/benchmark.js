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
var MOMENT = "./files/moment.min.js"
var JSON = "./files/input.json";
var JS = "./files/sample.js";

function benchmark(repeat, withIO) {
  var _underscore = fs.readFileSync(UNDERSCORE);
  var _moment = fs.readFileSync(MOMENT);
  var _json = fs.readFileSync(JSON);
  var _js = fs.readFileSync(JS);

  stopWatch.start();
  for (var i=0; i<repeat; i++) {
    var context = vm.createContext();

    // underscore
    var underscore = withIO ? fs.readFileSync(UNDERSCORE) : _underscore;
    vm.runInContext(underscore, context);

    // moment
    var moment = withIO ? fs.readFileSync(MOMENT) : _moment;
    vm.runInContext(moment, context);

    // json
    var json = withIO ? fs.readFileSync(JSON) : _json;
    vm.runInContext('json='+json, context);

    // js
    var js = withIO ? fs.readFileSync(JS) : _js;
    result = vm.runInContext(js, context);

    if (result!=1350) throw new Exception("Value is wrong!");
  }

  var elapsed = stopWatch.elapsed();
  var avg = elapsed / repeat;
  console.log("Done %d times: %d sec. avg: %d (IO=%s)", repeat, elapsed, avg, withIO);
}

benchmark(1000, true);
benchmark(1000, false);

