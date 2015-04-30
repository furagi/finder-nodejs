path = require 'path'
FilesController = require path.resolve('app/controllers/files')

module.exports = (app) ->
    files = new FilesController()
    app.delete '/files/:id', files.allow_only_admin, files.destroy
