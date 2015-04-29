orm = require 'node-orm'
async = require 'async'
_ = require 'underscore'
path = require 'path'
fs = require 'fs'
ApplicationController = require './application'

module.exports = class FilesController extends ApplicationController
    Files = orm.models.file

    destroy: (req, res) ->
        async.waterfall [
            (next) -> Files.get req.params.id, next
            (file, next) ->
                unless file
                    next new Error "Can't find file"
                else
                    file.remove next
        ], (err) ->
            if err
                res.status(500).send err.message or err
            else
                res.end()
