path = require 'path'
girls_helpers = require path.resolve('app/helpers/girls')
ApplicationController = require path.resolve('app/controllers/application')

module.exports = (app) ->
    application = new ApplicationController()
    app.get '/admin', application.allow_only_admin, application.admin
    app.get '/', girls_helpers, application.index
