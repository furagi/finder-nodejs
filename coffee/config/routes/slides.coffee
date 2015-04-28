path = require 'path'
SlidesController = require path.resolve('app/controllers/slides')

module.exports = (app) ->
    slides = new SlidesController()
    app.post '/slides', slides.allow_only_admin, slides.create
    app.delete '/slides/:id', slides.allow_only_admin, slides.destroy
