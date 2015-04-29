_ = require 'underscore'
path = require 'path'
fs = require 'fs'

module.exports = (db) ->
    Files = db.define 'file', {
            file_id: {type: 'serial', key: on}
            path: {type: 'text'}
            size: {type: 'integer', size: 8}
            type: {type: 'enum', values: ['photo', 'video']}
            is_main: {type: 'boolean', default: false}
        }, {
            hooks: {
                beforeRemove: (callback) ->
                    true_path = @path.replace /^\/static/, path.resolve('public')
                    fs.unlink true_path, callback
            }
        }

    Files.hasOne 'girl', db.models.girl, {}, {
        field: 'girl_id'
        autoFetch: true
        autoFetchLimit: 2
        reverse: "files"
    }
