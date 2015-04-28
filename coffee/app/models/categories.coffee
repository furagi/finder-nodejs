_ = require 'underscore'
async = require 'async'

module.exports = (db) ->
    Categories = db.define 'category', {
            category_id: {type: 'serial', key: on}
            name: {type: 'text', size: 100}
        }, {
            methods: {}
        }

    Categories.hasMany 'girls', db.models.girl, {}, {
        autoFetch: true
        mergeTable: 'girl_to_category'
        getAccessor: 'get_girls'
    }
