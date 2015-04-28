path = require 'path'
CategoriesController = require path.resolve('app/controllers/categories')

module.exports = (app) ->
    categories = new CategoriesController()
    app.get '/categories', categories.index
    app.use /^\/categories.*/, categories.allow_only_admin
    app.post '/categories', categories.create
    app.post '/categories/:id', categories.update
    app.delete '/categories/:id', categories.destroy
