#= require jquery/jquery.min
#= require bootstrap/bootstrap.min
#= require underscore/underscore.min
#= require_tree mylibs
#

send_request = (options) ->
    $.ajax options
        .done (result) ->
            if result?.redirect
                document.location = result.redirect
                return
        .fail (result) ->
            console.log 'Error happened'

$ ->
    $('[data-form_submit]').click ->
        $form = $(@).closest '[data-form]'
        url = $form.data 'action'
        method = $form.data 'method'
        fields = $form.find '[data-form_field]'
        data = {}
        fields.each (index, field) ->
            $field = $ field
            source = $field.data 'form_field_source'
            value = ''
            if typeof $field[source] is 'function'
                value = $field[source]()
            else
                value = $field[source]
            default_value = $field.data 'form_field_default_value'
            if value and value isnt '' and value isnt default_value
                data[$field.data 'form_field' ] = value
        if ['patch', 'post'].indexOf(method.toLowerCase()) > -1 and _.isEmpty(data)
            return false
        else
            send_request {url, method, data}

