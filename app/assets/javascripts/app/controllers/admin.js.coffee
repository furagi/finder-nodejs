'use strict'


AdminCtrl = ($scope, Category, Application, Slide) ->
    $scope.categories = Category.query()
    $scope.slides = Slide.query()
    new Application({id: 'socials'}).$get (res) ->
        $scope.socials = res
    new Application({id: 'title'}).$get (res) ->
        $scope.title = res
    new Application({id: 'description'}).$get (res) ->
        $scope.description = res

    $scope.save_socials = ->
        $scope.socials.$save()

    $scope.save_hero = ->
        $scope.title.$save()
        $scope.description.$save()
        save_slides()

    $scope.uploading_slides = []

    $scope.add_slides = ($files) ->
        _.each $files, (file) ->
            slide = new Slide {file: file}
            $scope.uploading_slides.push slide

    save_slides = ->
        lefts = $scope.uploading_slides.length
        _.each $scope.uploading_slides, (slide, index) ->
            $scope.uploading_slides[index].create (_slide) ->
                lefts--
                if lefts is 0
                    $scope.uploading_slides = []
                if _slide
                    $scope.slides.push _slide

    $scope.delete_slide = (slide) ->
        index = -1
        _.find $scope.slides, (_slide, _index) ->
            if _slide.file_id is slide.file_id
                index = _index
                return on
        $scope.slides[index].$delete ->
            $scope.slides.splice index, 1

    $scope.abort_slide_uploading = (slide) ->
        if slide.uploading
            slide.abort()
            return
        index = -1
        _.find $scope.uploading_slides, (_slide, _index) ->
            if _slide.file_id is slide.file_id
                index = _index
                return on
        $scope.uploading_slides.splice index, 1






finder_controllers = angular.module 'finder_controllers'
finder_controllers.controller 'AdminCtrl', [
    '$scope'
    'Category'
    'Application'
    'Slide'
    AdminCtrl
]
