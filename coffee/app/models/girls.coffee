_ = require 'underscore'
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
            add_photo: (callback) ->
                callback()
        }
    }

    Girls.hasMany 'categories', db.models.category, {}, {
        autoFetch: true
        mergeTable: 'girl_to_category'
        getAccessor: 'get_categories'
    }
