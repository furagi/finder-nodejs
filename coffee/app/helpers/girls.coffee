_ = require 'underscore'

get_categories = (girl) ->
    unless girl.categories?.length
        return []
    _.map girl.categories, (category) ->
        "category-#{category.category_id}"

get_main_photo = (girl) ->
    main = _.find girl.files, (file) -> file.is_main
    return main?.path

module.exports = (req, res, next) ->
    res.locals.girls_helpers = {
        get_categories
        get_main_photo
    }
    next()
