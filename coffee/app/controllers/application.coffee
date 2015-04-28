orm = require 'node-orm'

module.exports = class ApplicationController
    Categories = orm.models.category
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
        res.render 'index'

    admin: (req, res) ->
        Categories.find {}, (err, categories) ->
            if err
                res.status(500).send err.message or err
            else
                res.locals.categories = categories
                res.render 'admin'
