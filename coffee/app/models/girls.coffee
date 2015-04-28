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
            add_file: (file, callback) ->
                async.waterfall [

                ]
                callback()
        }
    }

    Girls.hasMany 'categories', db.models.category, {}, {
        autoFetch: true
        mergeId: 'girl_id'
        mergeAssocId: 'category_id'
        # reverse: 'girls'
        mergeTable: 'girl_to_category'
        getAccessor: 'get_categories'
        setAccessor: 'set_categories'
    }
