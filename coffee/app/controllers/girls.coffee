orm = require 'node-orm'
async = require 'async'
_ = require 'underscore'
path = require 'path'
ApplicationController = require './application'

module.exports = class SessionsController extends ApplicationController
    Girls = orm.models.girl
    Files = orm.models.file
    Categories = orm.models.category

    index: (req, res) ->
        Girls.all (err, girls) ->
            if err
                res.status(500).send err.message or err
            else
                res.send girls

    create: (req, res) ->
        name = req.param 'name'
        unless typeof name is 'string' and name isnt ''
            res.status(400).send "Wrong name"
            return
        file = req.files?.file
        unless file?.type?.match? /^(image|video)/
            res.status(400).send "Wrong file"
            return
        description = req.param 'description'
        categories = req.param('categories') or []
        if typeof categories is 'string'
            try
                categories = JSON.parse categories
            catch e
                categories = []

        async.waterfall [
            (next) -> Girls.create {name, description}, next
            (girl, next) ->
                unless categories?.length > 0
                    next null, girl
                    return
                categories = _.map categories, (category) -> new Categories category
                girl.add_categories categories, next
            (girl, next) ->
                file.is_main = on
                file.path = file.path.replace path.resolve('public'), '/static'
                file.type = 'photo'
                file = new Files file
                girl.add_files [file], next
        ], (err, girl) ->
            if err
                res.status(500).send err.message or err
            else
                res.send girl


    update: (req, res) ->
        name = req.param 'name'
        unless typeof name is 'string' and name isnt ''
            res.status(400).send "Wrong name"
            return
        description = req.param 'description'
        categories = req.param 'categories'
        if typeof categories is 'string'
            try
                categories = JSON.parse categories
            catch e
                categories = []
        file = req.files?.file
        if file and not file.type?.match? /^(image|video)/
            res.status(400).send "Wrong file"
            return
        async.waterfall [
            (next) -> Girls.get req.params.id, next
            (girl, next) ->
                unless girl
                    next new Error "Can't find girl"
                else
                    girl.name = name
                    if description
                        girl.description = description
                    girl.save next
            (girl, next) ->
                unless categories?.length > 0
                    next null, girl
                    return
                categories = _.map categories, (category) -> new Categories category
                girl.update_categories categories, next
            (girl, next) ->
                unless file
                    next null, girl
                    return
                file.path = file.path.replace path.resolve('public'), '/static'
                file.type = 'photo'
                file = new Files file
                girl.add_files [file], next
        ], (err, girl) ->
            if err
                res.status(500).send err.message or err
            else
                res.send girl


    destroy: (req, res) ->
        async.waterfall [
            (next) -> Girls.get req.params.id, next
            (girl, next) ->
                unless girl
                    next new Error "Can't find girl"
                else
                    girl.remove next
        ], (err) ->
            if err
                res.status(500).send err.message or err
            else
                res.end()

    add_file: (req, res) ->
        file = req.files?.file
        unless file?
            res.status(400).send "Wrong file"
            return
        id = req.params.id
        async.waterfall [
            (next) -> girl = Girls.get id, next
            (girl, next) ->
                unless girl.files.length > 0
                    file.is_main = on
                file.path = file.path.replace path.resolve('public'), '/static'
                file.type = 'photo'
                file = new Files file
                girl.setFiles file, next
        ], (err, girl) ->
            if err
                res.status(500).send err.message or err
            else
                res.send girl




    destroy_file: (req, res) ->
        async.waterfall [
            (next) -> Girls.get req.params.id, next
            (girl, next) ->
                unless girl
                    next new Error "Can't find girl"
                else
                    girl.remove next
        ], (err) ->
            if err
                res.status(500).send err.message or err
            else
                res.redirect req.headers.referer or '/admin'
