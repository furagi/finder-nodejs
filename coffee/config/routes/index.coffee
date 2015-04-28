_ = require 'underscore'

routes = [
    'application'
    'categories'
    'girls'
    'sessions'
    'slides'
]

module.exports = (app) ->
	_.each routes, (route) ->
		require("./#{route}") app
