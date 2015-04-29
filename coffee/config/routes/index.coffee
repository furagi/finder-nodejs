_ = require 'underscore'

routes = [
    'application'
    'categories'
    'files'
    'girls'
    'sessions'
    'slides'
]

module.exports = (app) ->
	_.each routes, (route) ->
		require("./#{route}") app
