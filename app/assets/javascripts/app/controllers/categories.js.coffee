'use strict'


CategoriesCtrl = ($scope, Category) ->
    $scope.new_category = new Category()
    $scope.current = null
    $scope.add = ->
        unless typeof $scope.new_category.name is 'string' and $scope.new_category.name isnt ''
            alert "Name can't be empty"
            return
        $scope.new_category.$save (category) ->
            $scope.categories.push category
    $scope.edit = (category) ->
        if category.editing
            category.$save ->
                $scope.current = null
                category.editing = off
            return
        if $scope.current
            $scope.current.editing = off
        category.editing = on
        $scope.current = category
    $scope.destroy = (category) ->
        if category.editing
            $scope.current = null
        index = $scope.categories.indexOf category
        category.$delete ->
            $scope.categories.splice index, 1

finder_controllers = angular.module 'finder_controllers'
finder_controllers.controller 'CategoriesCtrl', [
    '$scope'
    'Category'
    CategoriesCtrl
]
