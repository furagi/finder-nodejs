'use strict';

finder_services = angular.module 'finder_services'

finder_services.factory 'Application', [
    '$resource'
    ($resource) ->
        return $resource '/application/:id', {
                id: '@id'
            }, {
            }
]
