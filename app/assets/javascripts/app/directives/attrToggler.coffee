'use strict'

finder_directives = angular.module 'finder_directives'

attrToggler = -> {
    link: (scope, elem, attrs) ->
        attributes = {}
        scope.$watch ->
            attributes = {}
            _.each elem[0].attributes, (attr) ->
                unless attr
                    return
                name = attr.name.match(/^attr-name-(.*)/)
                if name
                    name = name[1]
                    unless eval(elem.attr "attr-toggle-#{name}")
                        elem.removeAttr(name);
                    else
                        elem.attr(name, name);
}

finder_directives.directive 'attrToggler', attrToggler
