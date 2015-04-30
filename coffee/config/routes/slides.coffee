path = require 'path'
multipart = require 'connect-multiparty'
SlidesController = require path.resolve('app/controllers/slides')

multipart = multipart {
    maxFieldsSize: 1024 * 1024 * 20
    uploadDir: path.resolve 'public/files'
}

module.exports = (app) ->
    slides = new SlidesController()
    app.get '/slides', slides.index
    app.post '/slides', slides.allow_only_admin, multipart, slides.create
    app.delete '/slides/:id', slides.allow_only_admin, slides.destroy
