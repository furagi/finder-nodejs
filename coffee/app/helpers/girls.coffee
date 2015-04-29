_ = require 'underscore'

get_categories = (girl) ->
    unless girl.categories?.length
        return []
    _.map girl.categories, (category) ->
        "category-id-#{category.category_id}"

module.exports = (req, res, next) ->
    res.locals.girls_helpers = {
        get_categories
    }
    next()
