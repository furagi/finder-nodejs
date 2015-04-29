'use strict';

finder_services = angular.module 'finder_services'

finder_services.factory 'Girl', [
    '$resource'
    '$upload'
    ($resource, $upload) ->
        Girl = $resource '/girls/:girl_id', {
                girl_id: '@girl_id'
            }, {
            }
        Girl::create = (callback) ->
            options = {
                url: "/girls"
                method: 'POST'
                file: @_files[0]
                data: {
                    categories: @categories
                    name: @name
                    description: @description
                }
            }
            uploader = $upload.upload options
            .progress (event) =>
                @progress = Math.round 100 * event.loaded / event.total
            .success (data, status, headers, config) =>
                # unless @files
                #     @files = []
                # @files.push data
                callback data

        Girl::add_file = (file, callback) ->
            unless @files_left?
                files_left = 0
            @files_left++
            uploader = $upload.upload {
                url: "/girls/#{@girl_id}/files"
                method: 'POST'
                file: file
            }
            .progress (event) =>
                @progress = Math.round 100 * event.loaded / event.total
            .error (err) ->
                callback err
            .success (data, status, headers, config) =>
                unless @files
                    @files = []
                @files.push data
                callback()
            .finally =>
                @files_left--
        Girl::main_photo = ->
            main = _.find @files, (file) ->
                file.type is 'photo' and file.is_main
            return main?.path
        Girl::has_category = (category) ->
            unless @categories?.length > 0
                return off
            result = _.find @categories, (_category) ->
                category.category_id is _category.category_id
            return result?
        Girl
]
