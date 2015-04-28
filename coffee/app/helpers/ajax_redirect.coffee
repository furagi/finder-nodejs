module.exports = (req, res, next) ->
    res.expressRedirect = res.redirect
    res.redirect = (args...) ->
        res.redirect = res.expressRedirect
        if req.xhr
            res.send {redirect: args[0]}
        else
            res.redirect args...
    next()

