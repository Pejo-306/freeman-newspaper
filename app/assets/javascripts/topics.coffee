# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

set_input_field_width = (identifier) ->
  # set new width of input field
  new_width = $('#topic-field-master').width() - $('#topic-field-tags').width()
  # I hardcode cuz I'm too lazy to figure this out
  $(identifier).parent().css 'width', "#{new_width - 6}px"
  return

raise_topic_field_errors = (reason) ->
  $('#topic-field-master').addClass 'input-error'
  if !$('#topic-field-errors').exists()
    error_message =
      if reason == 'non-existent'
        'This topic does not exist.'
      else if reason == 'already included'
        'This topic has already been included.'
      else if reason == 'no topics'
        'Your article must be associated with at least one topic.'
      else if reason == 'empty input'
        'Input cannot be empty'
      else
        'Unknown error encountered.'

    error_element = $("
      <div id=\"topic-field-errors\" class=\"alert alert-danger\">
        <p>#{error_message}</p>
      </div>
    ")
    error_element.insertBefore $('#topic-field-master')
  return

suppress_topic_field_errors = () ->
  # remove input error css class if it has been applied
  $('#topic-field-master').removeClass 'input-error'
  $('#topic-field-errors').remove()
  return

add_topic_tag = (name) ->
  $('#topic-field-tags').append(
    '<span class="tag badge badge-light"></span>'
  )
  $('#topic-field-tags span.tag:last-child').append(
    "<span>#{name}</span>",
    '<span class="delimiter"> | </span>',
    '<a href="#" class="tag-delete-link">x</a>'
  )
  set_input_field_width '#topic-field-input'

  # add topic name to hidden input field
  $('#topic-field-data').val "#{$('#topic-field-data').val()}#{name}, "
  return

color_subelements = (parent, colors) ->
  $(parent).children().each (index) ->
    topic_holder = $(@).children().first()

    if not topic_holder.hasClass('colored_topic_holder')
      topic_holder.css 'background-color', Colors.get_random_color(colors)
      topic_holder.addClass 'colored_topic_holder'
    return
  return

$(document).on 'click', '.tag-delete-link', (e) ->
  # prevent link redirect
  e.preventDefault()

  # remove topic's name from the input
  topic_name = @parentElement.firstElementChild.innerText
  $('#topic-field-data').val($('#topic-field-data').val().replace("#{topic_name}, ", ''))

  # remove topic tag
  @parentElement.remove()
  set_input_field_width('#topic-field-input')
  return

$(document).on 'turbolinks:load', ->
  # prevent form submission on enter keypress
  $('form.new_article').on 'keyup keypress', (e) ->
    key = e.which or e.keyCode
    if key == 13
      e.preventDefault()
      return false
    return
  $('form.edit_article').on 'keyup keypress', (e) ->
    key = e.which or e.keyCode
    if key == 13
      e.preventDefault()
      return false
    return

  # topic input field logic
  $('#topic-field-input').keypress (e) ->
    key = e.which or e.keyCode
    # the enter key code
    if key == 13
      if @value.is_blank()
        # input value cannot be empty
        @value = ''
        suppress_topic_field_errors()
        raise_topic_field_errors 'empty input'
        return

      topic_exists = undefined
      $.ajax
        url: "/topics/exists/#{@value}"
        type: 'GET'
        dataType: 'json'
        async: false
        success: (data) ->
            topic_exists = data['exists']
            return

      if topic_exists
        # remove input error css class if it has been applied
        suppress_topic_field_errors()

        if $('#topic-field-data').val().includes @value
          # topic has already been inputted
          suppress_topic_field_errors()
          raise_topic_field_errors 'already included'
        else
          # add the topic tag
          add_topic_tag @value
          # reset field input
          @value = ''
      else
        suppress_topic_field_errors()
        raise_topic_field_errors 'non-existent'
    return

  # topic field focus
  $('#topic-field-input').focus (e) ->
    $('#topic-field-master').css 'box-shadow', '0 0 0 .15rem #d1d2ff'
    $('#topic-field-master').css 'border', '1px solid #83b0ff'
    return
  $('#topic-field-input').focusout (e) ->
    suppress_topic_field_errors()
    $('#topic-field-master').css 'box-shadow', 'none'
    $('#topic-field-master').css 'border', 'none'
    return

  # prevent form submission on empty data field
  $('input[name=commit]').click (e) ->
    if $('#topic-field-data').val().is_blank()
      if $('#topic-field-input').val().is_blank()
        $('#topic-field-input').val ''

      e.preventDefault()
      suppress_topic_field_errors()
      raise_topic_field_errors 'no topics'
    return

  set_input_field_width('#topic-field-input')

  # color preloaded elements
  color_subelements '#topics-list', Colors.universal_colors
  # color dynamically added DOM elements
  $('#topics-list').on 'DOMSubtreeModified', ->
    color_subelements @, Colors.universal_colors
    return
  return

