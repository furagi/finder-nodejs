'use strict'


GirlsCtrl = ($scope, Girl, Category) ->
    $scope.current = new Girl()
    $scope.girls = Girl.query()
    $scope.test = off

    $scope.edit = (girl) ->
        $scope.current = girl
        $scope.current._categories = {
        }
        _.each $scope.categories, (category) ->
            unless $scope.current.categories?.length
                $scope.current._categories[category.category_id] = off
                return
            result = _.find $scope.current.categories, (_category) ->
                category.category_id is _category.category_id
            $scope.current._categories[category.category_id] = result?
    $scope.save = (callback) ->
        unless typeof $scope.current.name is 'string' and $scope.current.name isnt ''
            alert "Fill name first"
            return
        unless typeof $scope.current.description is 'string' and $scope.current.description isnt ''
            alert "Fill description first"
            return
        $scope.current.categories = []
        _.each $scope.current._categories, (has, category_id) ->
            if has
                $scope.current.categories.push category_id
        index = -1
        if $scope.current.girl_id?
            _.each $scope.girls, (girl, _index) ->
                if girl.girl_id is $scope.current.girl_id
                    index = _index
        $scope.current.$save (girl) ->
            if index is -1
                $scope.girls.push girl
            else
                $scope.girls.splice index, 1, girl
            $scope.current = girl
            if typeof callback is 'function'
                callback()
    $scope.destroy = (girl) ->
        if girl.editing
            $scope.current = null
        index = $scope.girls.indexOf girl
        girl.$delete ->
            $scope.girls.splice index, 1
    $scope.add_file = ($files) ->
        $scope.save ->
            $scope.current.add_file $files[0], (err) ->
                if err?
                    alert err.data or err.statusText or err
                    return
                index = -1
                _.each $scope.girls, (girl, _index) ->
                    if girl.girl_id is $scope.current.girl_id
                        index = _index
                if index > -1
                    $scope.girls[index] = $scope.current
    $scope.clear = ->
        $scope.current = new Girl()

finder_controllers = angular.module 'finder_controllers'
finder_controllers.controller 'GirlsCtrl', [
    '$scope'
    'Girl'
    'Category'
    GirlsCtrl
]
