// Generated by CoffeeScript 1.8.0
var ApplicationController, SessionsController, orm,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

orm = require('node-orm');

ApplicationController = require('./application');

module.exports = SessionsController = (function(_super) {
  var Girls;

  __extends(SessionsController, _super);

  function SessionsController() {
    return SessionsController.__super__.constructor.apply(this, arguments);
  }

  Girls = orm.models.girl;

  SessionsController.prototype.index = function(req, res) {
    return Girls.all(function(err, girls) {
      if (err) {
        return res.status(500).send(err.message || err);
      } else {
        return re.send(girls);
      }
    });
  };

  SessionsController.prototype.create = function(req, res) {
    var description, name;
    name = req.param('name');
    description = req.param('description');
    if (!(typeof name === 'string' && name !== '')) {
      res.status(400).end();
      return;
    }
    return Girls.create({
      name: name
    }, function(err) {
      if (err) {
        return res.status(500).send(err.message || err);
      } else {
        return res.redirect(req.headers.referer || '/admin');
      }
    });
  };

  SessionsController.prototype.update = function(req, res) {
    var name;
    name = req.param('name');
    if (!(typeof name === 'string' && name !== '')) {
      res.status(400).end();
      return;
    }
    return async.waterfall([
      function(next) {
        return Girls.one({
          category_id: req.params.id
        }, next);
      }, function(category, next) {
        if (!category) {
          return next(new Error("Can't find category"));
        } else {
          category.name = name;
          return category.save(next);
        }
      }
    ], function(err) {
      if (err) {
        return res.status(500).send(err.message || err);
      } else {
        return res.redirect(req.headers.referer || '/admin');
      }
    });
  };

  SessionsController.prototype.destroy = function(req, res) {
    return async.waterfall([
      function(next) {
        return Girls.one({
          category_id: req.params.id
        }, next);
      }, function(category, next) {
        if (!category) {
          return next(new Error("Can't find category"));
        } else {
          return category.remove(next);
        }
      }
    ], function(err) {
      if (err) {
        return res.status(500).send(err.message || err);
      } else {
        return res.redirect(req.headers.referer || '/admin');
      }
    });
  };

  SessionsController.prototype.add_file = function(req, res) {};

  SessionsController.prototype.destroy_file = function(req, res) {
    return async.waterfall([
      function(next) {
        return Girls.one({
          category_id: req.params.id
        }, next);
      }, function(category, next) {
        if (!category) {
          return next(new Error("Can't find category"));
        } else {
          return category.remove(next);
        }
      }
    ], function(err) {
      if (err) {
        return res.status(500).send(err.message || err);
      } else {
        return res.redirect(req.headers.referer || '/admin');
      }
    });
  };

  return SessionsController;

})(ApplicationController);
