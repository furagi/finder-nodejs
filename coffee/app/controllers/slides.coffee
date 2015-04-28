async = require 'async'
fs = require 'fs'
ApplicationController = require './application'

module.exports = class SliderController extends ApplicationController

    create: (req, res) ->
        name = req.param 'name'
        unless typeof name is 'string' and name isnt ''
            res.status(400).end()
            return
        Slider.create {name}, (err, category) ->
            if err
                res.status(500).send err.message or err
            else
                res.send category

    destroy: (req, res) ->
        async.waterfall [
            (next) -> Slider.one {category_id: req.params.id}, next
            (category, next) ->
                unless category
                    next new Error "Can't find category"
                else
                    category.remove next
        ], (err) ->
            if err
                res.status(500).send err.message or err
            else
                res.end()
