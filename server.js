// Generated by CoffeeScript 1.8.0
var Application, application, http;

http = require('http');

Application = require('./config/application');

application = new Application();

application.init(function(app) {
  http.createServer(app).listen(settings.PORT, settings.HOST);
  return logger.info('Server started at port ' + settings.PORT);
});
