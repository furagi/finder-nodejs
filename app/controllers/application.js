// Generated by CoffeeScript 1.8.0
var ApplicationController, orm,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

orm = require('node-orm');

module.exports = ApplicationController = (function() {
  var Categories;

  function ApplicationController() {
    this.allow_only_admin = __bind(this.allow_only_admin, this);
  }

  Categories = orm.models.category;

  ApplicationController.prototype.check_is_authenticated = function(req, res, next) {
    if (!req.session.user) {
      req.session.wanted_url = req.url;
      return res.redirect('/sessions/new');
    } else {
      return next();
    }
  };

  ApplicationController.prototype.allow_only_admin = function(req, res, next) {
    return this.check_is_authenticated(req, res, function() {
      if (!req.session.user.is_admin) {
        return res.status(403).end();
      } else {
        return next();
      }
    });
  };

  ApplicationController.prototype.index = function(req, res) {
    return res.render('index');
  };

  ApplicationController.prototype.admin = function(req, res) {
    return Categories.find({}, function(err, categories) {
      if (err) {
        return res.status(500).send(err.message || err);
      } else {
        res.locals.categories = categories;
        return res.render('admin');
      }
    });
  };

  return ApplicationController;

})();
