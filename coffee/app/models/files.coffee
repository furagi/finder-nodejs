_ = require 'underscore'
fd = require 'fs'
module.exports = (db) ->
    Files = db.define 'file', {
            file_id: {type: 'serial', key: on}
            path: {type: 'text'}
            size: {type: 'integer', size: 8}
            type: {type: 'enum', values: ['photo', 'video']}
            is_main: {type: 'boolean', default: false}
        }, {
            hooks: {
                afterRemove: (callback) ->
                    fs.unlink @path, callback
            }
        }

    Files.hasOne 'girl', db.models.girl, {}, {
        autoFetch: true
        reverse: "files"
    }
