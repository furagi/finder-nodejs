'use strict';

finder_services = angular.module 'finder_services'

finder_services.factory 'FileResource', [
    '$resource'
    ($resource) ->
        return $resource '/files/:file_id', {
                file_id: '@file_id'
            }, {
            }
]
