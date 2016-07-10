# ycall

Simplifies interop between [co](https://www.npmjs.com/package/co) (promise / generator-based) and callbacks (both node-style nodebacks where the first parameter is an error, and regular callbacks).

## Features

* Can turn generators into a callback function (using `cbify`) or a node-style nodeback-based function (using `cbify_node`). If the resulting function is not passed a callback, an ES6 Promise is returned.
* Can `yield` callback-based functions in generators (using `yify` or `ycall`), as well as node-style nodeback-based functions (using `yify_node` or `ycall_node`).
* All features of generators wrapped with [co](https://www.npmjs.com/package/co) (such as yielding Promises) can be used generators wrapped with `cbify` and `cbify_node`.

## Example: Turning a generator into a callback/promise-based function with cbify

```
var {cbify} = require('ycall');

var cbify_example = cbify(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cbify_example(function(x) { console.log(x) }); // 5
cbify_example().then(function(x) { console.log(x) }); // 5
```

## Example: Using callback-based functions in generators with yify

```
var {cbify, ycall} = require('ycall');

var yify_example_with_arguments = cbify(function*(a, b) {
  var result = yield yify(add_async)(5, 1); // 6
  return result + a + b;
});

yify_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15
yify_example_with_arguments(2, 7).then(function(x) { console.log(x) }); // 15
```

## Example: Using callback-based functions in generators with ycall

```
var {cbify, ycall} = require('ycall');

var ycall_example_with_arguments = cbify(function*(a, b) {
  var result = yield ycall(add_async, 5, 1); // 6
  return result + a + b;
});

ycall_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15
ycall_example_with_arguments(2, 7).then(function(x) { console.log(x) }); // 15
```

## Install

```
npm install ycall
```

## Usage

For the purpose of these examples, we assume you have required the library as follows:

```
var {cbify, cbify_node, ycall, ycall_node, yify, yify_node} = require('ycall');
```

## API

For the purpose of these examples, we assume you have required the library as follows:

```
var {cbify, cbify_node, ycall, ycall_node, yify, yify_node} = require('ycall');
```

Additionally, we will be using the following callback/nodeback-based functions in the examples:

```
function addone_async(x, callback) {
  setTimeout(function() {
    callback(x + 1);
  }, 1000);
}
```

```
function addone_async_node(x, nodeback) {
  setTimeout(function() {
    nodeback(null, x + 1);
  }, 1000);
}
```

### cbify

`cbify` creates a callback-style function from a generator

```
var cbify_example = cbify(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cbify_example(function(x) { console.log(x) }); // 5
```

If the last argument is not a function, a promise will be returned instead:

```
cbify_example().then(function(x) { console.log(x) }); // 5
```

### cbify_node

`cbify_node` creates a nodeback-style function from a generator


```
var cbify_node_example = cbify_node(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cbify_node_example(function(err, x) { console.log(x) }); // 5
```

If the last argument is not a function, a promise will be returned instead:

```
cbify_node_example().then(function(x) { console.log(x) });
```

### yify

`yify` transforms a callback-style function into a promise which can be yielded within a generator.

```
function add_async(x, y, callback) {
  setTimeout(function() {
    callback(x + y);
  }, 1000);
}

var yify_example_with_arguments = cbify(function*(a, b) {
  var result = yield yify(add_async)(5, 1); // 6
  return result + a + b;
});

yify_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15
```

### yify_node

`yify_node` transforms a nodeback-style function into a promise which can be yielded within a generator.

```
function add_async_node(x, y, nodeback) {
  setTimeout(function() {
    nodeback(null, x + 1);
  }, 1000);
}

var yify_node_example_with_arguments = cbify_node(function*(a, b) {
  var result = yield yify_node(add_async_node)(5, 1); // 6
  return result + a + b;
});

yify_node_example_with_arguments(2, 7, function(err, x) { console.log(x) }); // 15
```

### ycall

`ycall` is a shorthand that calls `yify` on a callback-based function and calls it with the remaining parameters. So `ycall(func, x, y)` is equivalent to `yify(func)(x, y)`

```
function add_async(x, y, callback) {
  setTimeout(function() {
    callback(x + y);
  }, 1000);
}

var ycall_example_with_arguments = cbify(function*(a, b) {
  var result = yield ycall(add_async, 5, 1); // 6
  return result + a + b;
});

ycall_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15
```

### ycall_node

`ycall_node` is a shorthand that calls `yify_node` on a nodeback-based function and calls it with the remaining parameters. So `ycall_node(func, x, y)` is equivalent to `yify_node(func)(x, y)`

```
function add_async_node(x, y, nodeback) {
  setTimeout(function() {
    nodeback(null, x + 1);
  }, 1000);
}

var ycall_node_example_with_arguments = cbify_node(function*(a, b) {
  var result = yield ycall_node(add_async_node, 5, 1); // 6
  return result + a + b;
});

ycall_node_example_with_arguments(2, 7, function(err, x) { console.log(x) }); // 15
```

## Credits

By [Geza Kovacs](https://github.com/gkovacs)
