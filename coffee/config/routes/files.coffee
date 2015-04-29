path = require 'path'
multipart = require 'connect-multiparty'
FilesController = require path.resolve('app/controllers/files')

multipart = multipart {
    maxFieldsSize: 1024 * 1024 * 20
    uploadDir: path.resolve 'public/files'
}

module.exports = (app) ->
    files = new FilesController()
    app.delete '/files/:id', files.allow_only_admin, files.destroy
