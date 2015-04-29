orm = require 'node-orm'

module.exports = class SessionsController
    User = orm.models.user

    create_show: (req, res) ->
        user = req.session.user
        if user
            root = if user.is_admin then '/admin' else '/'
            url = req.session.wanted_url
            if url is '/sessions/new' or not url
                url = root
            res.redirect url
        else
            res.locals.title = "MDLS'teem login"
            res.render 'sessions/new'

    create: (req, res) ->
        email = req.body.email
        password = req.body.password
        if not (email? and password?)
            res.render 'sessions/new', {message: 'Parameters email or/and password are missed'}
            return
        new User({email: email, password: password}).login (err, user) ->
            if err
                logger.warn err
                res.render 'sessions/new', {message: err.message or err}
            else
                root = if user.is_admin then '/admin' else '/'
                url = req.session.wanted_url or root
                req.session.user = user
                # to fix strange bug with favicon.ico
                if url is '/favicon.ico'
                    url = root
                res.redirect url

    destroy: (req, res) ->
        req.session.destroy()
        res.redirect '/sessions/new'
