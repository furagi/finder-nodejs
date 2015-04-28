path = require 'path'
ApplicationController = require path.resolve('app/controllers/application')

module.exports = (app) ->
    application = new ApplicationController()
    app.get '/admin', application.allow_only_admin, application.admin
    app.get '/', application.index
