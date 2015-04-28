orm = require 'node-orm'
async = require 'async'
ApplicationController = require './application'

module.exports = class SessionsController extends ApplicationController
    Girls = orm.models.girl

    index: (req, res) ->
        Girls.all (err, girls) ->
            if err
                res.status(500).send err.message or err
            else
                res.send girls

    create: (req, res) ->
        name = req.param 'name'
        description = req.param 'description'

        unless typeof name is 'string' and name isnt ''
            res.status(400).end()
            return
        Girls.create {name, description}, (err, girl) ->
            if err
                res.status(500).send err.message or err
            else
                res.send girl


    update: (req, res) ->
        name = req.param 'name'
        description = req.param 'description'
        unless typeof name is 'string' and name isnt ''
            res.status(400).end()
            return
        async.waterfall [
            (next) -> Girls.one {girl_id: req.params.id}, next
            (girl, next) ->
                unless girl
                    next new Error "Can't find girl"
                else
                    girl.name = name
                    if description
                        girl.description = description
                    girl.save next
        ], (err, girl) ->
            if err
                res.status(500).send err.message or err
            else
                res.send girl


    destroy: (req, res) ->
        async.waterfall [
            (next) -> Girls.one {girl_id: req.params.id}, next
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

    add_file: (req, res) ->



    destroy_file: (req, res) ->
        async.waterfall [
            (next) -> Girls.one {girl_id: req.params.id}, next
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
