var {
  yify,
  cbify,
  ycall,
} = require('./index'); // require('ycall')

var cbify_example = cbify(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cbify_example(function(x) { console.log(x) }); // 5

cbify_example().then(function(x) { console.log(x) }); // 5

function add_async(x, y, callback) {
  setTimeout(function() {
    callback(x + y);
  }, 1000);
}

var ycall_example = cbify(function*() {
  var result = yield ycall(add_async, 5, 1); // 6
  return result;
});

ycall_example(function(x) { console.log(x) }); // 6

var yify_example = cbify(function*() {
  var result = yield yify(add_async)(5, 1); // 6
  return result;
});

yify_example(function(x) { console.log(x) }); // 6

function addone_multiarg_callback_async(x, callback) {
  setTimeout(function() {
    callback(x + 1, 'foo', 'bar');
  }, 1000);
}

var ycall_example_with_arguments = cbify(function*(a, b) {
  var result = yield ycall(add_async, 5, 1); // 6
  return result + a + b;
});

ycall_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15

var yify_example_with_arguments = cbify(function*(a, b) {
  var result = yield yify(add_async)(5, 1); // 6
  return result + a + b;
});

yify_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15

var ycall_example_multiarg_callback = cbify(function*() {
  var [result, result2, result3] = yield ycall(addone_multiarg_callback_async, 5); // result=6, result2='foo', result3='bar'
  return [result, result2, result3];
});

ycall_example_multiarg_callback(function(x) { console.log(x) }); // [6, 'foo', 'bar']

var yify_example_multiarg_callback = cbify(function*() {
  var [result, result2, result3] = yield yify(addone_multiarg_callback_async)(5); // result=6, result2='foo', result3='bar'
  return [result, result2, result3];
});

yify_example_multiarg_callback(function(x) { console.log(x) }); // [6, 'foo', 'bar']

var sleep = cbify(function*(time) {
  function sleep_base(msecs, callback) {
    setTimeout(callback, msecs);
  }
  yield yify(sleep_base)(time);
});

var sleep_example = cbify(function*() {
  yield sleep(3000); // sleeps for 3 seconds
  return 7;
});

sleep_example(function(x) { console.log(x) }); // 7
