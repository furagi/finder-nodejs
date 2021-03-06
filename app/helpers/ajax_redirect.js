// Generated by CoffeeScript 1.8.0
var __slice = [].slice;

module.exports = function(req, res, next) {
  res.expressRedirect = res.redirect;
  res.redirect = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    res.redirect = res.expressRedirect;
    if (req.xhr) {
      return res.send({
        redirect: args[0]
      });
    } else {
      return res.redirect.apply(res, args);
    }
  };
  return next();
};
