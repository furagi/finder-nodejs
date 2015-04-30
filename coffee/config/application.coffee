cookie_parser = require 'cookie-parser'
body_parser = require 'body-parser'
method_override = require 'method-override'
assets = require 'connect-assets'
express = require 'express'
path = require 'path'
session = require 'express-session'
MemcachedStore = require('connect-memjs')(session)
async = require 'async'
_ = require 'underscore'
require './settings'
GlobalLogger = require(path.resolve 'app/helpers/log')
request_logger = require path.resolve 'app/helpers/request_logger'
error_handler = require path.resolve 'app/helpers/error_handler'
ajax_redirect = require path.resolve 'app/helpers/ajax_redirect'
routes = require path.resolve 'config/routes/'
models = require path.resolve 'app/models/'
Finder = require path.resolve 'app/models/finder'

class Application

    init: (callback) ->
        @config_logger()
        app = express()
        app.use body_parser.json()
        app.use body_parser.urlencoded({ extended: true })
        app.use method_override()
        app.set 'views', path.resolve('app/views')
        app.set 'view engine', 'jade'
        @config_mincer app
        app.use '/static', express.static(path.resolve 'public')
        app.use cookie_parser()
        session_store = new MemcachedStore settings.memcached
        app.use session({
            key    : settings.session.cookie_name
            secret : settings.session.cookie_secret
            store  : session_store
            cookie : {
                path: '/',
                httpOnly: true,
                maxAge: 604800000 # week age
            }
        })
        app.use request_logger
        app.use ajax_redirect
        models (err) ->
            if err?
                throw err
            else
                routes app
                app.use error_handler
                settings.Finder = Finder
                callback app

    config_logger: ->
        log_level = process.argv[2];
        if not log_level
            log_level = 'info'
        _logger = new GlobalLogger log_level, settings.project_name
        Object.defineProperty global, 'logger', {
            get: -> _logger
        }

        process.on 'uncaughtException', (err) ->
            logger.error 'Exception: ' + err.stack
            setTimeout(->
                    process.exit(1);
                , 100
            )
        @logger = logger

    config_mincer: (app) ->
        assets_config = {
            servePath: 'assets'
            paths: [
                path.resolve 'app/assets/stylesheets'
                path.resolve 'app/assets/javascripts'
                path.resolve 'vendor/assets/stylesheets'
                path.resolve 'vendor/assets/javascripts'
            ]
        }
        assets_config.compile = on
        if process.env.NODE_ENV is 'production'
            assets_config.build = on
            assets_config.buildDir = path.resolve settings.mincer_cache
            assets_config.compress = on
            assets_config.fingerprinting = on
        app.use assets(assets_config)




module.exports = Application
