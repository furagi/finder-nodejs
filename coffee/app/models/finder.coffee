_ = require 'underscore'
fs = require 'fs'
path = require 'path'
finder_path = path.resolve 'config/local.finder.json'
Finder = require finder_path

Finder.save = (callback) ->
    str = ''
    try
        str = JSON.stringify Finder, null, 4
    catch e
        callback new Error "Can't stringify Finder"
        return
    fs.writeFile finder_path, str, callback

module.exports = Finder
