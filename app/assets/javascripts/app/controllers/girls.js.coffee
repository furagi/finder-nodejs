'use strict'


GirlsCtrl = ($scope, Girl, Category) ->
    $scope.current = new Girl()
    $scope.girls = Girl.query()

    $scope.edit = (girl) ->
        $scope.current = girl
    $scope.save = ->
        unless typeof $scope.current.name is 'string' and $scope.current.name isnt ''
            alert "Fill name first"
            return
        unless typeof $scope.current.description is 'string' and $scope.current.description isnt ''
            alert "Fill description first"
            return
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
    $scope.destroy = (girl) ->
        if girl.editing
            $scope.current = null
        index = $scope.girls.indexOf girl
        girl.$delete ->
            $scope.girls.splice index, 1
    $scope.add_file = ($files) ->
        unless typeof $scope.current.name is 'string' and $scope.current.name isnt ''
            alert "Fill name first"
            return
        unless typeof $scope.current.description is 'string' and $scope.current.description isnt ''
            alert "Fill description first"
            return
        $scope.current.$save ->
            $scope.current.file = $files[0]
            $scope.current.add_file (err, girl) ->
                if err?
                    alert err.data or err.statusText or err
                else
                    $scope.girls.push girl
                    $scope.current = girl
    $scope.clear = ->
        $scope.current = new Girl()

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
