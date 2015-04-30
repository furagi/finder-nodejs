'use strict'


AdminCtrl = ($scope, Category, Application) ->
    $scope.categories = Category.query()
    $scope.slides = []
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


finder_controllers = angular.module 'finder_controllers'
finder_controllers.controller 'AdminCtrl', [
    '$scope'
    'Category'
    'Application'
    AdminCtrl
]
