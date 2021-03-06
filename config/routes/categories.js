// Generated by CoffeeScript 1.8.0
var CategoriesController, path;

path = require('path');

CategoriesController = require(path.resolve('app/controllers/categories'));

module.exports = function(app) {
  var categories;
  categories = new CategoriesController();
  app.get('/categories', categories.index);
  app.use(/^\/categories.*/, categories.allow_only_admin);
  app.post('/categories', categories.create);
  app.post('/categories/:id', categories.update);
  return app["delete"]('/categories/:id', categories.destroy);
};
