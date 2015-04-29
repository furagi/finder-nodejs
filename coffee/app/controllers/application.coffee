orm = require 'node-orm'
async = require 'async'
module.exports = class ApplicationController
    Categories = orm.models.category
    Girls = orm.models.girl
    check_is_authenticated: (req, res, next) ->
        unless req.session.user
            req.session.wanted_url = req.url
            res.redirect '/sessions/new'
        else
            next()

    allow_only_admin: (req, res, next) =>
        @check_is_authenticated req, res, ->
            unless req.session.user.is_admin
                res.status(403).end()
            else
                next()

    index: (req, res) ->
        res.locals.title = "MDLS'teem"
        async.parallel {
            categories: Categories.all
            girls: Girls.all
        }, (err, results) ->
            if err
                res.status(500).send err.messsage or err
            else
                res.locals.girls = results.girls or []
                res.locals.categories = results.categories or []
                res.render 'application/index'

    admin: (req, res) ->
        res.locals.title = 'ADMIN'
        res.render 'application/admin'
