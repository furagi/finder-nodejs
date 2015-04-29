#= require angular-file-upload/angular-file-upload-html5-shim
#= require angular/angular.min
#= require angular-file-upload/angular-file-upload
#= require angular/angular-cookies.min
#= require angular/angular-resource.min
#= require angular/angular-route.min
#= require_self
#= require_tree ./app/controllers
#= require_tree ./app/services
#= require_tree ./app/directives
#
'use strict';


# Declare app level module which depends on filters, and services
admin_app = angular.module 'admin_app', [
    'ngRoute'
    'angularFileUpload'
    'finder_controllers'
    'finder_services'
    'finder_directives'
]

admin_app.config([
    '$routeProvider'
    ($routeProvider) ->
        $routeProvider.when('/', {
                controller: 'AdminCtrl'
            }).otherwise({
                redirectTo: '/'
            })
])


finder_directives = angular.module 'finder_directives', ['ngCookies']

finder_services = angular.module 'finder_services', [
    'ngResource'
]
.config [
    '$provide'
    '$httpProvider',
    ($provide, $httpProvider) ->
        $provide.factory "myHttpInterceptor", ($q, $log) ->
            responseError: (rejection) ->
                $log.debug "error with status #{rejection.status} and data: #{rejection.data.message or rejection.data}"
                switch rejection.status
                    when 401
                        window.location = '/sessions/new'
                        return
                    when 0
                        $log.error "No connection, internet is down?"
                    else
                        alert "#{rejection.data.message or rejection.data}"
                        $log.error "#{rejection.data['message']}"

                # do something on error
                $q.reject rejection
        $httpProvider.interceptors.push 'myHttpInterceptor'
]

#finder_filters = angular.module 'finder_filters', []

finder_controllers = angular.module 'finder_controllers', []
