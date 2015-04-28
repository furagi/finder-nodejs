// Generated by CoffeeScript 1.8.0
var ApplicationController, path;

path = require('path');

ApplicationController = require(path.resolve('app/controllers/application'));

module.exports = function(app) {
  var application;
  application = new ApplicationController();
  app.get('/admin', application.allow_only_admin, application.admin);
  return app.get('/', application.index);
};
