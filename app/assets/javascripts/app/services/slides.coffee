'use strict';

finder_services = angular.module 'finder_services'

finder_services.factory 'Slide', [
    '$resource'
    '$upload'
    ($resource, $upload) ->
        Slide =  $resource '/slides/:slide_id', {
                slide_id: '@file_id'
            }, {
            }
        Slide::create = (callback) ->
            options = {
                url: "/slides"
                method: 'POST'
                file: @file
            }
            @progress = 0
            @uploading = on
            finish = (slide) =>
                @_uploader = null
                @finished = on
                @progress = 0
                callback slide
            @_uploader = $upload.upload options
            .progress (event) =>
                @progress = Math.round 100 * event.loaded / event.total
            .success (slide, status, headers, config) ->
                slide = new Slide slide
                finish slide
            .error ->
                finish()
            .then ->
                finish()

        Slide::abort = ->
            if @_uploader
                @_uploader.abort()

        return Slide
]
