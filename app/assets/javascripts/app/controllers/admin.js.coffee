'use strict'


AdminCtrl = ($scope, Category) ->
    $scope.categories = Category.query()

finder_controllers = angular.module 'finder_controllers'
finder_controllers.controller 'AdminCtrl', [
    '$scope'
    'Category'
    AdminCtrl
]
