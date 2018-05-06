# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

set_input_field_width = (identifier) ->
  # set new width of input field
  new_width = $('#topic-field-master').width() - $('#topic-field-tags').width()
  # I hardcode cuz I'm too lazy to figure this out
  $(identifier).parent().css('width', "#{new_width - 6}px")
  return

$(document).on 'turbolinks:load', ->
  $('#new_article').on 'keyup keypress', (e) ->
    key = e.which or e.keyCode
    if key == 13
      e.preventDefault()
      return false
    return

  $('#topic-field-input').keypress (e) ->
    key = e.which or e.keyCode
    if key == 13
      # the enter key code
      $('#topic-field-tags').append(
        '<span class="tag badge badge-light"></span>'
      )
      $('#topic-field-tags span.tag:last-child').append(
        "<span>#{e.target.value}</span>",
        '<span class="delimiter"> | </span>',
        '<a href="#" class="tag-delete-link">x</a>'
      )

      set_input_field_width('#topic-field-input')
      # reset field
      @value = ''
    return

  set_input_field_width('#topic-field-input')

  $('#topic-field-input').focus (e) ->
    $('#topic-field-master').css 'box-shadow', '0 0 0 .15rem #d1d2ff'
    $('#topic-field-master').css 'border', '1px solid #83b0ff'
    return
  $('#topic-field-input').focusout (e) ->
    $('#topic-field-master').css 'box-shadow', 'none'
    $('#topic-field-master').css 'border', 'none'
    return
  return

$(document).on 'click', '.tag-delete-link', (e) ->
  e.preventDefault()
  @parentElement.remove()
  set_input_field_width('#topic-field-input')
  return

