'use strict';

finder_services = angular.module 'finder_services'

finder_services.factory 'Girl', [
    '$resource'
    ($resource) ->
        Girl = $resource '/girls/:girl_id', {
                girl_id: '@girl_id'
            }, {
            }
        Girl::add_file = (callback) ->
            unless @files_left?
                files_left = 0
            @files_left++
            $upload.upload {
                url: "/girls/#{@girl_id}/files"
                method: 'POST'
                file: @file
            }
            .error (err) ->
                callback err
            .success (data, status, headers, config) =>
                @files.push data
                @save callback
            .always ->
                @files_left--
        Girl
]
