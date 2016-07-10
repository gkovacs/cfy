# ycall

Simplifies interop between [co](https://www.npmjs.com/package/co) (promise / generator-based) async functions, and async callback-based functions (both node-style nodebacks where the first parameter is an error, and regular callbacks).

## Features

* Write callback-based async functions using generators (using `cbify`). Can also write node-style ("nodeback") async functions (using `cbify_node`). If the resulting function is not passed a callback, an ES6 Promise is returned.
* Can `yield` callback-based functions in generators (using `yify`), as well as node-style nodeback-based functions (using `yify_node`).
* All features of generators wrapped with [co](https://www.npmjs.com/package/co) (such as yielding Promises) can be used generators wrapped with `cbify` and `cbify_node`.

## Install

```
npm install ycall
```

## Usage

For the purpose of these examples, we assume you have required the library as follows:

```javascript
var {cbify, cbify_node, ycall, ycall_node, yify, yify_node} = require('ycall');
```

## Examples

### Turning a generator into a callback/promise-based async function

```javascript
var {cbify} = require('ycall');

var cbify_example = cbify(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cbify_example(function(x) { console.log(x) }); // 5
cbify_example().then(function(x) { console.log(x) }); // 5
```

### Using callback-based async functions in generators

```javascript
var {cbify, yify} = require('ycall');

var yify_example_with_arguments = cbify(function*(a, b) {
  var result = yield yify(add_async)(5, 1); // 6
  return result + a + b;
});

yify_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15
yify_example_with_arguments(2, 7).then(function(x) { console.log(x) }); // 15
```

## API

### cbify

`cbify` creates a callback-style function from a generator

```javascript
var cbify_example = cbify(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cbify_example(function(x) { console.log(x) }); // 5
```

If the last argument is not a function, a promise will be returned instead:

```javascript
cbify_example().then(function(x) { console.log(x) }); // 5
```

### cbify_node

`cbify_node` creates a nodeback-style function from a generator


```javascript
var cbify_node_example = cbify_node(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cbify_node_example(function(err, x) { console.log(x) }); // 5
```

If the last argument is not a function, a promise will be returned instead:

```javascript
cbify_node_example().then(function(x) { console.log(x) });
```

### yify

`yify` transforms a callback-style function into a promise which can be yielded within a generator.

```javascript
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

```javascript
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

```javascript
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

```javascript
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

## More Examples

You will find more examples in [`example.js`](https://github.com/gkovacs/ycall/blob/master/example.js) (for interop with normal callback-based async functions) and [`example_node.js`](https://github.com/gkovacs/ycall/blob/master/example_node.js) (for interop with node-style nodeback-based async functions). The unit tests include examples of usage from Livescript.

## Credits

By [Geza Kovacs](https://github.com/gkovacs)
