_ = require 'underscore'
fs = require 'fs'
async = require 'async'

module.exports = (db) ->
    Girls = db.define 'girl', {
        girl_id: {type: 'serial', key: on}
        name: {type: 'text', size: 100}
        description: {type: 'text', size: 1000}
        rating: {type: 'number', defaultValue: 0}
        profile_photo: {type: 'text'}
    }, {
        methods: {
            add_categories: (categories, callback) ->
                async.waterfall [
                    (next) => @set_categories categories, next
                    (categories, next) => Girls.get @girl_id, next
                ], (err, girl) =>
                    unless err
                        @categories = girl.categories
                    callback err, @

            update_categories: (categories, callback) ->
                unless @categories?.length > 0
                    @add_categories categories, callback
                    return
                update_categories_ids = _.map categories, (category) -> category.category_id
                deleted_diff = @categories.filter (category) ->
                    update_categories_ids.indexOf(category.category_id) is -1
                self_categories_ids = @categories.map (category) -> category.category_id
                added_diff = _.filter categories, (category) ->
                    self_categories_ids.indexOf(category.category_id) is -1
                async.waterfall [
                    (next) => @delete_categories deleted_diff, next
                    (categories, next) => @set_categories added_diff, next
                    (categories, next) => Girls.get @girl_id, next
                ], (err, girl) =>
                    unless err
                        @categories = girl.categories
                    callback err, @
        }
    }

    Girls.hasMany 'categories', db.models.category, {}, {
        autoFetch: true
        mergeId: 'girl_id'
        mergeAssocId: 'category_id'
        # reverse: 'girls'
        delAccessor: 'delete_categories'
        mergeTable: 'girl_to_category'
        getAccessor: 'get_categories'
        setAccessor: 'set_categories'
    }
