path = require 'path'
SessionsController = require path.resolve('app/controllers/sessions')

module.exports = (app) ->
	sessions = new SessionsController()
	app.post '/sessions', sessions.create

	app.get '/sessions/new', sessions.create_show
	app.delete '/sessions/logout', sessions.destroy
