require! {
  co
  denodeify
  unthenify
}

export yfy = (f) ->
  denodeify f, (...res) ->
    if res.length == 1
      return [null, res[0]]
    else
      return [null, [...res]]

export yfy_node = (f) ->
  denodeify f, (err, ...res) ->
    if res.length == 1
      return [err, res[0]]
    else
      return [err, [...res]]

export cfy = (f) ->
  wrapped = co.wrap(f)
  return (...args, callback) ->
    if typeof(callback) == 'function'
      return wrapped.bind(this)(...args).then(callback, (err) -> console.log(err))
    else
      return wrapped.bind(this)(...args, callback)

export cfy_node = (f) ->
  wrapped = co.wrap(f)
  wrapped_cb = unthenify(wrapped)
  return (...args, callback) ->
    if typeof(callback) == 'function'
      return wrapped_cb.bind(this)(...args, callback)
    else
      return wrapped.bind(this)(...args, callback)

export ycall = (f, ...args) ->
  yfy(f)(...args)

export ycall_node = (f, ...args) ->
  yfy_node(f)(...args)
