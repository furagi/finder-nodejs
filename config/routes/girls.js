// Generated by CoffeeScript 1.8.0
var GirlsController, multipart, path;

path = require('path');

multipart = require('connect-multiparty');

GirlsController = require(path.resolve('app/controllers/girls'));

multipart = multipart({
  maxFieldsSize: 1024 * 1024 * 20,
  uploadDir: path.resolve('public/files')
});

module.exports = function(app) {
  var girls;
  girls = new GirlsController();
  app.get('/girls', girls.index);
  app.post('/girls', girls.allow_only_admin, multipart, girls.create);
  app["delete"]('/girls/:id', girls.allow_only_admin, girls.destroy);
  app.post('/girls/:id', girls.allow_only_admin, multipart, girls.update);
  return app.post('/girls/:id/change_main_photo', girls.allow_only_admin, girls.change_main_photo);
};
