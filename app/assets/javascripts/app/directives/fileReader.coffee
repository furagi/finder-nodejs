'use strict'

finder_directives = angular.module 'finder_directives'

fileReader = ->
    {
        require: '?ngModel'
        link: (scope, element, attributes, ngModel) ->
            element.bind "change", (change_event) ->
                extension = change_event.target.files[0].name.split('.').pop()
                if extension is 'jpg'
                    ngModel.$setViewValue change_event.target.files[0]
                    scope.$apply()
                    scope.$eval attributes.fileReader
                else
                    ngModel.$setViewValue off
                    scope.$apply()
    }

finder_directives.directive 'fileReader', fileReader
