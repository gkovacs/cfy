var {
  yify_node,
  cbify_node,
  ycall_node,
  cbify,
} = require('./index'); // require('ycall')

var cbify_node_example = cbify_node(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cbify_node_example(function(err, x) { console.log(x) }); // 5

cbify_node_example().then(function(x) { console.log(x) });

function add_async_node(x, y, nodeback) {
  setTimeout(function() {
    nodeback(null, x + 1);
  }, 1000);
}

var ycall_node_example = cbify_node(function*() {
  var result = yield ycall_node(add_async_node, 5, 1); // 6
  return result;
});

ycall_node_example(function(err, x) { console.log(x) }); // 6

var yify_node_example = cbify_node(function*() {
  var result = yield yify_node(add_async_node)(5, 1); // 6
  return result;
});

yify_node_example(function(err, x) { console.log(x) }); // 6

var yify_nodeback_to_callback_example = cbify(function*() {
  var result = yield yify_node(add_async_node)(5, 1); // 6
  return result;
});

yify_nodeback_to_callback_example(function(x) { console.log(x) }); // 6

var yify_node_example_with_arguments = cbify_node(function*(a, b) {
  var result = yield yify_node(add_async_node)(5, 1); // 6
  return result + a + b;
});

yify_node_example_with_arguments(2, 7, function(err, x) { console.log(x) }); // 15

var ycall_node_example_with_arguments = cbify_node(function*(a, b) {
  var result = yield ycall_node(add_async_node, 5, 1); // 6
  return result + a + b;
});

ycall_node_example_with_arguments(2, 7, function(err, x) { console.log(x) }); // 15

