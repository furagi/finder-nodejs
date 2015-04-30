path = require 'path'
girls_helpers = require path.resolve('app/helpers/girls')
ApplicationController = require path.resolve('app/controllers/application')

module.exports = (app) ->
    application = new ApplicationController()
    app.use '/application/:id', application.allow_only_admin
    app.get '/application/admin', application.admin
    app.get '/application/:id', application.show
    app.post '/application/:id', application.update

    app.get '/', girls_helpers, application.index
