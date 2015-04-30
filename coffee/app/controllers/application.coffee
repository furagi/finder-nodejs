orm = require 'node-orm'
async = require 'async'
module.exports = class ApplicationController
    Categories = orm.models.category
    Girls = orm.models.girl
    Files = orm.models.file
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
        res.locals.title = settings.Finder.title
        async.parallel {
            categories: Categories.all
            girls: Girls.all
            slides: Files.find({}).where("girl_id IS NULL").all
        }, (err, results) ->
            if err
                res.status(500).send err.messsage or err
            else
                res.locals.girls = results.girls or []
                res.locals.categories = results.categories or []
                res.locals.slides = results.slides or []
                res.locals.socials = settings.Finder.socials
                res.locals.description = settings.Finder.description
                res.render 'application/index'

    admin: (req, res) ->
        res.locals.title = 'ADMIN'
        res.locals.socials = settings.Finder.socials
        res.render 'application/admin'

    show: (req, res) ->
        res.send {id: req.params.id, value: settings.Finder[req.params.id]}

    update: (req, res) ->
        settings.Finder[req.params.id] = req.param 'value'
        settings.Finder.save (err) ->
            if err
                res.status(500).send err.messsage or err
            else
                res.send {id: req.params.id, value: settings.Finder[req.params.id]}
