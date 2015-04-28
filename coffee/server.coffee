http = require 'http'
Application = require './config/application'

application = new Application()
application.init (app) ->
	http.createServer(app).listen settings.PORT, settings.HOST
	logger.info 'Server started at port ' + settings.PORT
