require! {
  co
  unthenify
}

export yfy = (f) ->
  return (...functionArguments) ->
    self = this
    return new Promise (resolve, reject) ->
      callbackFunction = (...args) ->
        return resolve(args[0])
      functionArguments.push(callbackFunction)
      f.apply(self, functionArguments)

export yfy_node = (f) ->
  return (...functionArguments) ->
    self = this
    return new Promise (resolve, reject) ->
      callbackFunction = (...args) ->
        err = args[0]
        if err
          return reject(err)
        return resolve(args[1])
      functionArguments.push(callbackFunction)
      f.apply(self, functionArguments)

export yfy_multi = (f) ->
  return (...functionArguments) ->
    self = this
    return new Promise (resolve, reject) ->
      callbackFunction = (...args) ->
        return resolve(args)
      functionArguments.push(callbackFunction)
      f.apply(self, functionArguments)

export yfy_multi_node = (f) ->
  return (...functionArguments) ->
    self = this
    return new Promise (resolve, reject) ->
      callbackFunction = (...args) ->
        err = args[0]
        if err
          return reject(err)
        return resolve(args.slice(1))
      functionArguments.push(callbackFunction)
      f.apply(self, functionArguments)

export cfy = (f, options) ->
  if options? and options.num_args?
    num_args = options.num_args
  else
    num_args = f.length
  wrapped = co.wrap(f)
  return (...args, callback) ->
    if args.length == num_args and typeof(callback) == 'function'
      # the callback was passed, call the function immediately
      return wrapped.bind(this)(...args).then(callback)
    else
      # return a promise
      return wrapped.bind(this)(...args, callback)

export cfy_node = (f, options) ->
  if options? and options.num_args?
    num_args = options.num_args
  else
    num_args = f.length
  wrapped = co.wrap(f)
  wrapped_cb = unthenify(wrapped)
  return (...args, callback) ->
    if args.length == num_args and typeof(callback) == 'function'
      # the callback was passed, call the function immediately
      return wrapped_cb.bind(this)(...args, callback)
    else
      # return a promise
      return wrapped.bind(this)(...args, callback)
