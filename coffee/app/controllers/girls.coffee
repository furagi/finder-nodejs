orm = require 'node-orm'
ApplicationController = require './application'

module.exports = class SessionsController extends ApplicationController
    Girls = orm.models.girl

    index: (req, res) ->
        Girls.all (err, girls) ->
            if err
                res.status(500).send err.message or err
            else
                re.send girls

    create: (req, res) ->
        name = req.param 'name'
        description = req.param 'description'

        unless typeof name is 'string' and name isnt ''
            res.status(400).end()
            return
        Girls.create {name}, (err) ->
            if err
                res.status(500).send err.message or err
            else
                res.redirect req.headers.referer or '/admin'


    update: (req, res) ->
        name = req.param 'name'
        unless typeof name is 'string' and name isnt ''
            res.status(400).end()
            return
        async.waterfall [
            (next) -> Girls.one {category_id: req.params.id}, next
            (category, next) ->
                unless category
                    next new Error "Can't find category"
                else
                    category.name = name
                    category.save next
        ], (err) ->
            if err
                res.status(500).send err.message or err
            else
                res.redirect req.headers.referer or '/admin'


    destroy: (req, res) ->
        async.waterfall [
            (next) -> Girls.one {category_id: req.params.id}, next
            (category, next) ->
                unless category
                    next new Error "Can't find category"
                else
                    category.remove next
        ], (err) ->
            if err
                res.status(500).send err.message or err
            else
                res.redirect req.headers.referer or '/admin'

    add_file: (req, res) ->



    destroy_file: (req, res) ->
        async.waterfall [
            (next) -> Girls.one {category_id: req.params.id}, next
            (category, next) ->
                unless category
                    next new Error "Can't find category"
                else
                    category.remove next
        ], (err) ->
            if err
                res.status(500).send err.message or err
            else
                res.redirect req.headers.referer or '/admin'
