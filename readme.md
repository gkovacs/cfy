# cfy - CallbackiFY

Simplifies interop between [co](https://www.npmjs.com/package/co) (promise / generator-based) async functions, and async callback-based functions (both node-style nodebacks where the first parameter is an error, and regular callbacks).

## Features

* Write callback-based async functions using generators (using `cfy`). Can also write node-style ("nodeback") async functions (using `cfy_node`). If the resulting function is not passed a callback, an ES6 Promise is returned.
* Can `yield` callback-based functions in generators (using `yfy`), as well as node-style nodeback-based functions (using `yfy_node`).
* All features of generators wrapped with [co](https://www.npmjs.com/package/co) (such as yielding Promises) can be used in generators wrapped with `cfy` and `cfy_node`.

## Install

```
npm install cfy
```

## Usage

For the purpose of these examples, we assume you have required the library as follows:

```javascript
var {cfy, cfy_node, ycall, ycall_node, yfy, yfy_node} = require('cfy');
```

## Examples

### Turning a generator into a callback/promise-based async function

```javascript
var {cfy} = require('cfy');

var cfy_example = cfy(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cfy_example(function(x) { console.log(x) }); // 5
cfy_example().then(function(x) { console.log(x) }); // 5
```

### Using callback-based async functions in generators

```javascript
var {cfy, yfy} = require('cfy');

var yfy_example_with_arguments = cfy(function*(a, b) {
  var result = yield yfy(add_async)(5, 1); // 6
  return result + a + b;
});

yfy_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15
yfy_example_with_arguments(2, 7).then(function(x) { console.log(x) }); // 15
```

### Writing a wrapper for setTimeout (sleep)

```javascript
var sleep = cfy(function*(time) {
  function sleep_base(msecs, callback) {
    setTimeout(callback, msecs);
  }
  yield yfy(sleep_base)(time);
});

var sleep_example = cfy(function*() {
  yield sleep(3000); // sleeps for 3 seconds
  return 7;
});

sleep_example(function(x) { console.log(x) }); // 7
```

## API

### cfy

`cfy` creates a callback-style function from a generator

```javascript
var cfy_example = cfy(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cfy_example(function(x) { console.log(x) }); // 5
```

If the last argument is not a function, a promise will be returned instead:

```javascript
cfy_example().then(function(x) { console.log(x) }); // 5
```

### cfy_node

`cfy_node` creates a nodeback-style function from a generator


```javascript
var cfy_node_example = cfy_node(function*() {
  var result = yield Promise.resolve(5); // 5
  return result;
});

cfy_node_example(function(err, x) { console.log(x) }); // 5
```

If the last argument is not a function, a promise will be returned instead:

```javascript
cfy_node_example().then(function(x) { console.log(x) });
```

### yfy

`yfy` transforms a callback-style function into a promise which can be yielded within a generator.

```javascript
function add_async(x, y, callback) {
  setTimeout(function() {
    callback(x + y);
  }, 1000);
}

var yfy_example_with_arguments = cfy(function*(a, b) {
  var result = yield yfy(add_async)(5, 1); // 6
  return result + a + b;
});

yfy_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15
```

### yfy_node

`yfy_node` transforms a nodeback-style function into a promise which can be yielded within a generator.

```javascript
function add_async_node(x, y, nodeback) {
  setTimeout(function() {
    nodeback(null, x + 1);
  }, 1000);
}

var yfy_node_example_with_arguments = cfy_node(function*(a, b) {
  var result = yield yfy_node(add_async_node)(5, 1); // 6
  return result + a + b;
});

yfy_node_example_with_arguments(2, 7, function(err, x) { console.log(x) }); // 15
```

### ycall

`ycall` is a shorthand that calls `yfy` on a callback-based function and calls it with the remaining parameters. So `ycall(func, x, y)` is equivalent to `yfy(func)(x, y)`

```javascript
function add_async(x, y, callback) {
  setTimeout(function() {
    callback(x + y);
  }, 1000);
}

var ycall_example_with_arguments = cfy(function*(a, b) {
  var result = yield ycall(add_async, 5, 1); // 6
  return result + a + b;
});

ycall_example_with_arguments(2, 7, function(x) { console.log(x) }); // 15
```

### ycall_node

`ycall_node` is a shorthand that calls `yfy_node` on a nodeback-based function and calls it with the remaining parameters. So `ycall_node(func, x, y)` is equivalent to `yfy_node(func)(x, y)`

```javascript
function add_async_node(x, y, nodeback) {
  setTimeout(function() {
    nodeback(null, x + 1);
  }, 1000);
}

var ycall_node_example_with_arguments = cfy_node(function*(a, b) {
  var result = yield ycall_node(add_async_node, 5, 1); // 6
  return result + a + b;
});

ycall_node_example_with_arguments(2, 7, function(err, x) { console.log(x) }); // 15
```

## More Examples

You will find more examples in [`example.js`](https://github.com/gkovacs/ycall/blob/master/example.js) (for interop with normal callback-based async functions) and [`example_node.js`](https://github.com/gkovacs/ycall/blob/master/example_node.js) (for interop with node-style nodeback-based async functions). The unit tests include examples of usage from Livescript.

## Credits

By [Geza Kovacs](https://github.com/gkovacs)
