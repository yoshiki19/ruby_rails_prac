# $(document).on 'turbolinks:load' , ->
#   $('a[data-remote]').on 'ajax:success', ->
#     $(this).parents('tr').remove()
$(document).ready ->
  $('a[data-remote]').on 'ajax:success', ->
    $(this).parents('tr').remove()
