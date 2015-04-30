orm = require 'node-orm'
async = require 'async'
_ = require 'underscore'
path = require 'path'
fs = require 'fs'
FilesController = require './files'

module.exports = class SlidesController extends FilesController
    Files = orm.models.file

    index: (req, res) ->
        Files.find({}).where("girl_id IS NULL").all (err, slides) ->
            if err
                res.status(500).send err.message or err
            else
                res.send slides

    create: (req, res) ->
        file = req.files?.file
        unless file?.type?.match? /^image/
            res.status(400).send "Wrong file"
            fs.unlink file.path, (err) ->
                if err
                    logger.warn "Error happened while tried to delete file", file
            return
        file.path = file.path.replace path.resolve('public'), '/static'
        file.type = 'photo'
        Files.create file, (err, _file) ->
            if err
                res.status(500).send err.message or err
            else
                res.send _file
