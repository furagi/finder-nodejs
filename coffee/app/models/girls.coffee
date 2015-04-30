_ = require 'underscore'
fs = require 'fs'
async = require 'async'

module.exports = (db) ->
    Girls = db.define 'girl', {
        girl_id: {type: 'serial', key: on}
        name: {type: 'text', size: 100}
        description: {type: 'text', size: 1000}
        rating: {type: 'number', defaultValue: 0}
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

            add_files: (files, callback) ->
                async.waterfall [
                    (next) => @setFiles files, next
                    (next) => Girls.get @girl_id, next
                ], (err, girl) =>
                    unless err
                        @files = girl.files
                    callback err, @

            change_main_photo: (file, callback) ->
                new_main = _.find @files, (_file) ->
                    file.file_id is _file.file_id
                unless new_main
                    callback new Error "Girl #{@girl_id} hasn't file #{file.file_id}"
                    return
                unless new_main.type is 'photo'
                    callback new Error "File #{file.file_id} isn't photo"
                    return
                if new_main.is_main
                    callback new Error "File #{file.file_id} already is main"
                    return
                old_main = _.find @files, (_file) ->
                    _file.is_main
                funcs = []
                if old_main
                    old_main.is_main = off
                    funcs.push old_main.save
                new_main.is_main = on
                funcs.push new_main.save
                async.series funcs, (err, files) =>
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
