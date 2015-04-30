_ = require 'underscore'
path = require 'path'
env = process.env.NODE_ENV
secrets = require './config.secure.json'
database = require './database.json'
_settings = require './settings.json'
[_settings, database] = [_settings, database].map (conf) -> conf[env] or conf.default

global.settings = _settings
settings.database = _.extend database, secrets[database.protocol]
settings.memcached = secrets.memcached
_.each _settings, (value, key) ->
    settings.__defineGetter__ key, -> return value
    settings.__defineSetter__ key, -> throw new Error "Changing settings.#{key} is deprecated"
