orm = require 'node-orm'
async = require 'async'
ApplicationController = require './application'

module.exports = class CategoriesController extends ApplicationController
    Categories = orm.models.category

    index: (req, res) ->
        Categories.all (err, categories) ->
            if err
                res.status(500).send err.message or err
            else
                res.send categories

    create: (req, res) ->
        name = req.param 'name'
        unless typeof name is 'string' and name isnt ''
            res.status(400).end()
            return
        Categories.create {name}, (err, category) ->
            if err
                res.status(500).send err.message or err
            else
                res.send category


    update: (req, res) ->
        name = req.param 'name'
        unless typeof name is 'string' and name isnt ''
            res.status(400).end()
            return
        async.waterfall [
            (next) -> Categories.one {category_id: req.params.id}, next
            (category, next) ->
                unless category
                    next new Error "Can't find category"
                else
                    category.name = name
                    category.save next
        ], (err, category) ->
            if err
                res.status(500).send err.message or err
            else
                res.send category


    destroy: (req, res) ->
        async.waterfall [
            (next) -> Categories.one {category_id: req.params.id}, next
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
