// Generated by LiveScript 1.5.0
(function(){
  var co, denodeify, unthenify, yfy, yfy_node, cfy, cfy_node, ycall, ycall_node, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
  co = require('co');
  denodeify = require('denodeify');
  unthenify = require('unthenify');
  out$.yfy = yfy = function(f){
    return denodeify(f, function(){
      var res, res$, i$, to$;
      res$ = [];
      for (i$ = 0, to$ = arguments.length; i$ < to$; ++i$) {
        res$.push(arguments[i$]);
      }
      res = res$;
      if (res.length === 1) {
        return [null, res[0]];
      } else {
        return [null, slice$.call(res)];
      }
    });
  };
  out$.yfy_node = yfy_node = function(f){
    return denodeify(f, function(err){
      var res, res$, i$, to$;
      res$ = [];
      for (i$ = 1, to$ = arguments.length; i$ < to$; ++i$) {
        res$.push(arguments[i$]);
      }
      res = res$;
      if (res.length === 1) {
        return [err, res[0]];
      } else {
        return [err, slice$.call(res)];
      }
    });
  };
  out$.cfy = cfy = function(f){
    var wrapped;
    wrapped = co.wrap(f);
    return function(){
      var i$, args, res$, j$, callback;
      res$ = [];
      for (j$ = 0 < (i$ = arguments.length - 1) ? 0 : (i$ = 0); j$ < i$; ++j$) {
        res$.push(arguments[j$]);
      }
      args = res$; callback = arguments[i$];
      if (typeof callback === 'function') {
        return wrapped.apply(null, args).then(callback, function(err){
          return console.log(err);
        });
      } else {
        return wrapped.apply(null, slice$.call(args).concat([callback]));
      }
    };
  };
  out$.cfy_node = cfy_node = function(f){
    var wrapped, wrapped_cb;
    wrapped = co.wrap(f);
    wrapped_cb = unthenify(wrapped);
    return function(){
      var i$, args, res$, j$, callback;
      res$ = [];
      for (j$ = 0 < (i$ = arguments.length - 1) ? 0 : (i$ = 0); j$ < i$; ++j$) {
        res$.push(arguments[j$]);
      }
      args = res$; callback = arguments[i$];
      if (typeof callback === 'function') {
        return wrapped_cb.apply(null, slice$.call(args).concat([callback]));
      } else {
        return wrapped.apply(null, slice$.call(args).concat([callback]));
      }
    };
    return unthenify(co.wrap(f));
  };
  out$.ycall = ycall = function(f){
    var args, res$, i$, to$;
    res$ = [];
    for (i$ = 1, to$ = arguments.length; i$ < to$; ++i$) {
      res$.push(arguments[i$]);
    }
    args = res$;
    return yfy(f).apply(null, args);
  };
  out$.ycall_node = ycall_node = function(f){
    var args, res$, i$, to$;
    res$ = [];
    for (i$ = 1, to$ = arguments.length; i$ < to$; ++i$) {
      res$.push(arguments[i$]);
    }
    args = res$;
    return yfy_node(f).apply(null, args);
  };
}).call(this);
