{
  yify
  cbify
  ycall
  yify_node
  cbify_node
  ycall_node
  sleep
  sleep_node
} = require('../index')

require! chai

chai.should()

add_async = (x, y, callback) ->
  setTimeout ->
    callback(x + y)
  , 0

add_async_node = (x, y, callback) ->
  setTimeout ->
    callback(null, x + y)
  , 0

describe 'all tests', ->

  specify 'cbify test callback', (done) ->
    f = cbify ->*
      yield Promise.resolve(5)
    result <- f()
    result.should.equal(5)
    done()

  specify 'cbify test promise', (done) ->
    f = cbify ->*
      yield Promise.resolve(5)
    result <- f().then()
    result.should.equal(5)
    done()

  specify 'cbify_node test callback', (done) ->
    f = cbify_node ->*
      yield Promise.resolve(5)
    err,result <- f()
    result.should.equal(5)
    done()

  specify 'cbify_node test promise', (done) ->
    f = cbify_node ->*
      yield Promise.resolve(5)
    result <- f().then()
    result.should.equal(5)
    done()

  specify 'yify test', (done) ->
    f = cbify ->*
      yield yify(add_async)(5, 1)
    result <- f()
    result.should.equal(6)
    done()

  specify 'yify_node test', (done) ->
    f = cbify ->*
      yield yify_node(add_async_node)(5, 1)
    result <- f()
    result.should.equal(6)
    done()

  specify 'ycall test', (done) ->
    f = cbify ->*
      yield ycall(add_async, 5, 1)
    result <- f()
    result.should.equal(6)
    done()

  specify 'ycall_node test', (done) ->
    f = cbify ->*
      yield ycall_node(add_async_node, 5, 1)
    result <- f()
    result.should.equal(6)
    done()

  specify 'cbify multiple arguments test', (done) ->
    f = cbify (x, y) ->*
      return 2 + 5
    result <- f(2, 5)
    result.should.equal(7)
    done()

  specify 'cbify multiple arguments nontrivial test', (done) ->
    f = cbify (x, y) ->*
      tmp = yield ycall(add_async, 3, 1)
      return tmp + x + y
    result <- f(2, 5)
    result.should.equal(11)
    done()

  specify 'cbify multiple arguments nontrivial promise test', (done) ->
    f = cbify (x, y) ->*
      tmp = yield ycall(add_async, 3, 1)
      return tmp + x + y
    result <- f(2, 5).then()
    result.should.equal(11)
    done()

  specify 'cbify yielding each other test', (done) ->
    f1 = cbify ->*
      return 3
    f2 = cbify ->*
      tmp = yield f1()
      return tmp + 1
    result <- f2()
    result.should.equal(4)
    done()

  specify 'cbify yielding each other test basic', (done) ->
    add_then_multiply = cbify (x, y, z) ->*
      tmp = x + y
      return tmp * z
    add_then_multiply_then_divide = cbify (x, y, z, a) ->*
      tmp = yield add_then_multiply(x, y, z)
      return tmp / a
    res1 <- add_then_multiply(2, 4, 3)
    res1.should.equal((2 + 4) * 3)
    res2 <- add_then_multiply_then_divide(2, 4, 3, 9)
    res2.should.equal((2 + 4) * 3 / 9)
    done()

  specify 'cbify yielding each other test nontrivial', (done) ->
    add_then_multiply = cbify (x, y, z) ->*
      tmp = yield yify(add_async)(x, y)
      return tmp * z
    add_then_multiply_then_divide = cbify (x, y, z, a) ->*
      tmp = yield add_then_multiply(x, y, z)
      return tmp / a
    res1 <- add_then_multiply(2, 4, 3)
    res1.should.equal((2 + 4) * 3)
    res2 <- add_then_multiply_then_divide(2, 4, 3, 9)
    res2.should.equal((2 + 4) * 3 / 9)
    done()

  specify 'yield setTimeout', (done) ->
    sleep = cbify (time) ->*
      sleep_base = (ntime, callback) ->
        setTimeout(callback, ntime)
      yield yify(sleep_base)(time)
    f = cbify ->*
      x = yield sleep(0)
      return 5
    result <- f()
    result.should.equal(5)
    done()

  specify 'yify redundant yify test', (done) ->
    sleep = cbify (time) ->*
      sleep_base = (ntime, callback) ->
        setTimeout(callback, ntime)
      yield yify(sleep_base)(time)
    f = cbify ->*
      x = yield yify(sleep)(0)
      return 5
    result <- f()
    result.should.equal(5)
    done()
