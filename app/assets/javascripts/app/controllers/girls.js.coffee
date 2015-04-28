'use strict'


GirlsCtrl = ($scope, Girl, Category) ->
    $scope.new_girl = new Girl()
    $scope.current = null
    $scope.add = ->
        $scope.new_girl.$save (girl) ->
            $scope.girls.push girl
    $scope.edit = (girl) ->
        if girl.editing
            girl.$save ->
                $scope.current = null
                girl.editing = off
            return
        if $scope.current
            $scope.current.editing = off
        girl.editing = on
        $scope.current = girl
    $scope.destroy = (girl) ->
        if girl.editing
            $scope.current = null
        index = $scope.girls.indexOf girl
        girl.$delete ->
            $scope.girls.splice index, 1

    # $scope.dmca_scan_types = ['torrent', 'page']
    # $scope.girls_loading = off
    # $scope.girls_left = on

    # $scope.new_dmca_scan = {}
    # $scope.new_dmca_scan.type = 'torrent'
    # $scope.format_date = format_date
    # $scope.format_status = format_status
    # $scope.get_torrent_name = get_torrent_name
    # $scope.get_hash = get_hash

    # $scope.init_form = (form_scope) ->
    #     $scope.form_scope = form_scope

    # $scope.add_girl = ->
    #     form = $scope.form_scope.form_new_dmca_scan
    #     if form.$invalid is on
    #         return
    #     if $scope.new_dmca_scan.type is 'torrent'
    #         if not ($scope.new_dmca_scan.torrent_url or $scope.new_dmca_scan.torrent_file)
    #             return
    #         if $scope.new_dmca_scan.torrent_file is off
    #             return


    #     dmca_scan = new Category $scope.new_dmca_scan
    #     dmca_scan.$save (new_dmca_scan) ->
    #             $scope.new_dmca_scan = {}
    #             $scope.new_dmca_scan.type = 'torrent'
    #             $scope.girls.push new_dmca_scan
    #         .catch (err) ->
    #             $scope.new_dmca_scan_error = err.data or err.statusText or err

    # $scope.next_page = ->
    #     Category.query {offset: $scope.girls.length}, (dmca_scans) ->
    #         $scope.girls = $scope.girls.concat dmca_scans

    # $scope.sort_by = (sorting_predicate) ->
    #     if $scope.sorting_predicate is sorting_predicate
    #         $scope.reverse = not $scope.reverse
    #     else
    #         $scope.sorting_predicate = sorting_predicate
    #         $scope.reverse = off


finder_controllers = angular.module 'finder_controllers'
finder_controllers.controller 'GirlsCtrl', [
    '$scope'
    'Girl'
    'Category'
    GirlsCtrl
]
