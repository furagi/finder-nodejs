// Generated by CoffeeScript 1.8.0
var ApplicationController, girls_helpers, path;

path = require('path');

girls_helpers = require(path.resolve('app/helpers/girls'));

ApplicationController = require(path.resolve('app/controllers/application'));

module.exports = function(app) {
  var application;
  application = new ApplicationController();
  app.use('/application/:id', application.allow_only_admin);
  app.get('/application/admin', application.admin);
  app.get('/application/:id', application.show);
  app.post('/application/:id', application.update);
  return app.get('/', girls_helpers, application.index);
};
