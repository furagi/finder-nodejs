_ = require 'underscore'

get_categories = (girl) ->
    unless girl.categories?.length
        return []
    _.map girl.categories, (category) ->
        "category-id-#{category.category_id}"

get_main_photo = (girl) ->
    girl.files.filter (file) ->
        file.is_main

module.exports = (req, res, next) ->
    res.locals.girls_helpers = {
        get_categories
    }
    next()
