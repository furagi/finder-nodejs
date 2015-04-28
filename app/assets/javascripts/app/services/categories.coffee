'use strict';

finder_services = angular.module 'finder_services'

finder_services.factory 'Category', [
    '$resource'
    ($resource) ->
        return $resource '/categories/:category_id', {
                category_id: '@category_id'
            }, {
            }
]
