{
  yfy
  cfy
  ycall
  yfy_node
  cfy_node
  ycall_node
  sleep
  sleep_node
} = require('../index')

require! {
  co
  chai
}

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

  specify 'cfy test callback', (done) ->
    f = cfy ->*
      yield Promise.resolve(5)
    result <- f()
    result.should.equal(5)
    done()

  specify 'cfy test promise', (done) ->
    f = cfy ->*
      yield Promise.resolve(5)
    result <- f().then()
    result.should.equal(5)
    done()

  specify 'cfy_node test callback', (done) ->
    f = cfy_node ->*
      yield Promise.resolve(5)
    err,result <- f()
    result.should.equal(5)
    done()

  specify 'cfy_node test promise', (done) ->
    f = cfy_node ->*
      yield Promise.resolve(5)
    result <- f().then()
    result.should.equal(5)
    done()

  specify 'yfy test', (done) ->
    f = cfy ->*
      yield yfy(add_async)(5, 1)
    result <- f()
    result.should.equal(6)
    done()

  specify 'yfy_node test', (done) ->
    f = cfy ->*
      yield yfy_node(add_async_node)(5, 1)
    result <- f()
    result.should.equal(6)
    done()

  specify 'ycall test', (done) ->
    f = cfy ->*
      yield ycall(add_async, 5, 1)
    result <- f()
    result.should.equal(6)
    done()

  specify 'ycall_node test', (done) ->
    f = cfy ->*
      yield ycall_node(add_async_node, 5, 1)
    result <- f()
    result.should.equal(6)
    done()

  specify 'cfy multiple arguments test', (done) ->
    f = cfy (x, y) ->*
      return 2 + 5
    result <- f(2, 5)
    result.should.equal(7)
    done()

  specify 'cfy multiple arguments nontrivial test', (done) ->
    f = cfy (x, y) ->*
      tmp = yield ycall(add_async, 3, 1)
      return tmp + x + y
    result <- f(2, 5)
    result.should.equal(11)
    done()

  specify 'cfy multiple arguments nontrivial promise test', (done) ->
    f = cfy (x, y) ->*
      tmp = yield ycall(add_async, 3, 1)
      return tmp + x + y
    result <- f(2, 5).then()
    result.should.equal(11)
    done()

  specify 'cfy yielding each other test', (done) ->
    f1 = cfy ->*
      return 3
    f2 = cfy ->*
      tmp = yield f1()
      return tmp + 1
    result <- f2()
    result.should.equal(4)
    done()

  specify 'cfy yielding each other test basic', (done) ->
    add_then_multiply = cfy (x, y, z) ->*
      tmp = x + y
      return tmp * z
    add_then_multiply_then_divide = cfy (x, y, z, a) ->*
      tmp = yield add_then_multiply(x, y, z)
      return tmp / a
    res1 <- add_then_multiply(2, 4, 3)
    res1.should.equal((2 + 4) * 3)
    res2 <- add_then_multiply_then_divide(2, 4, 3, 9)
    res2.should.equal((2 + 4) * 3 / 9)
    done()

  specify 'cfy yielding each other test nontrivial', (done) ->
    add_then_multiply = cfy (x, y, z) ->*
      tmp = yield yfy(add_async)(x, y)
      return tmp * z
    add_then_multiply_then_divide = cfy (x, y, z, a) ->*
      tmp = yield add_then_multiply(x, y, z)
      return tmp / a
    res1 <- add_then_multiply(2, 4, 3)
    res1.should.equal((2 + 4) * 3)
    res2 <- add_then_multiply_then_divide(2, 4, 3, 9)
    res2.should.equal((2 + 4) * 3 / 9)
    done()

  specify 'yield setTimeout', (done) ->
    sleep = cfy (time) ->*
      sleep_base = (ntime, callback) ->
        setTimeout(callback, ntime)
      yield yfy(sleep_base)(time)
    f = cfy ->*
      x = yield sleep(0)
      return 5
    result <- f()
    result.should.equal(5)
    done()

  specify 'yfy redundant yfy test', (done) ->
    sleep = cfy (time) ->*
      sleep_base = (ntime, callback) ->
        setTimeout(callback, ntime)
      yield yfy(sleep_base)(time)
    f = cfy ->*
      x = yield yfy(sleep)(0)
      return 5
    result <- f()
    result.should.equal(5)
    done()

  specify 'retain this baseline', (done) ->
    this.x = 3
    f = (callback) ->
      callback(this.x)
    res1 <~ f()
    res2 <~ f.bind(this)()
    3.should.not.equal(res1)
    3.should.equal(res2)
    done()

  specify 'retain this with cfy', (done) ->
    this.x = 3
    f = cfy ->*
      return this.x
    res1 <~ f()
    res2 <~ f.bind(this)()
    3.should.not.equal(res1)
    3.should.equal(res2)
    done()


  specify 'retain this with cfy_node', (done) ->
    this.x = 3
    f = cfy_node ->*
      return this.x
    err1,res1 <~ f()
    err2,res2 <~ f.bind(this)()
    3.should.not.equal(res1)
    3.should.equal(res2)
    done()
