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
        Girl::save = (callback) ->
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
            if @girl_id?
                options.url += "/#{@girl_id}"
            uploader = $upload.upload options
            .progress (event) =>
                @progress = Math.round 100 * event.loaded / event.total
            .success (girl, status, headers, config) =>
                girl = new Girl girl
                callback girl

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
