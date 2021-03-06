// Generated by CoffeeScript 1.8.0
var Application, Finder, GlobalLogger, MemcachedStore, ajax_redirect, assets, async, body_parser, cookie_parser, error_handler, express, method_override, models, path, request_logger, routes, session, _;

cookie_parser = require('cookie-parser');

body_parser = require('body-parser');

method_override = require('method-override');

assets = require('connect-assets');

express = require('express');

path = require('path');

session = require('express-session');

MemcachedStore = require('connect-memjs')(session);

async = require('async');

_ = require('underscore');

require('./settings');

GlobalLogger = require(path.resolve('app/helpers/log'));

request_logger = require(path.resolve('app/helpers/request_logger'));

error_handler = require(path.resolve('app/helpers/error_handler'));

ajax_redirect = require(path.resolve('app/helpers/ajax_redirect'));

routes = require(path.resolve('config/routes/'));

models = require(path.resolve('app/models/'));

Finder = require(path.resolve('app/models/finder'));

Application = (function() {
  function Application() {}

  Application.prototype.init = function(callback) {
    var app, session_store;
    this.config_logger();
    app = express();
    app.use(body_parser.json());
    app.use(body_parser.urlencoded({
      extended: true
    }));
    app.use(method_override());
    app.set('views', path.resolve('app/views'));
    app.set('view engine', 'jade');
    this.config_mincer(app);
    app.use('/static', express["static"](path.resolve('public')));
    app.use(cookie_parser());
    session_store = new MemcachedStore(settings.memcached);
    app.use(session({
      key: settings.session.cookie_name,
      secret: settings.session.cookie_secret,
      store: session_store,
      cookie: {
        path: '/',
        httpOnly: true,
        maxAge: 604800000
      }
    }));
    app.use(request_logger);
    app.use(ajax_redirect);
    return models(function(err) {
      if (err != null) {
        throw err;
      } else {
        routes(app);
        app.use(error_handler);
        settings.Finder = Finder;
        return callback(app);
      }
    });
  };

  Application.prototype.config_logger = function() {
    var log_level, _logger;
    log_level = process.argv[2];
    if (!log_level) {
      log_level = 'info';
    }
    _logger = new GlobalLogger(log_level, settings.project_name);
    Object.defineProperty(global, 'logger', {
      get: function() {
        return _logger;
      }
    });
    process.on('uncaughtException', function(err) {
      logger.error('Exception: ' + err.stack);
      return setTimeout(function() {
        return process.exit(1);
      }, 100);
    });
    return this.logger = logger;
  };

  Application.prototype.config_mincer = function(app) {
    var assets_config;
    assets_config = {
      servePath: 'assets',
      paths: [path.resolve('app/assets/stylesheets'), path.resolve('app/assets/javascripts'), path.resolve('vendor/assets/stylesheets'), path.resolve('vendor/assets/javascripts')]
    };
    assets_config.compile = true;
    if (process.env.NODE_ENV === 'production') {
      assets_config.build = true;
      assets_config.buildDir = path.resolve(settings.mincer_cache);
      assets_config.compress = true;
      assets_config.fingerprinting = true;
    }
    return app.use(assets(assets_config));
  };

  return Application;

})();

module.exports = Application;
