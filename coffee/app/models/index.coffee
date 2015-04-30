orm = require 'node-orm'
async = require 'async'
_ = require 'underscore'

models = [
	{file: 'categories', model_name: 'category'}
	{file: 'girls', model_name: 'girl'}
	{file: 'files', model_name: 'file'}
	{file: 'users', model_name: 'user'}
]


module.exports = (callback) ->
	logger.debug 'Connecting to DB'
	orm.settings.set 'instance.cache', off
	orm.connect settings.database, (err, db) ->
		if err?
			throw new Error "Can't connect to DB: #{err}"
			return
		_.each models, (model) ->
			require("./#{model.file}") db

		orm.models = db.models
		logger.debug 'Connected'
		callback()
