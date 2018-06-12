$(document).on 'turbolinks:load', ->
  if $('form.new_comment').exists()
    content_field = $('textarea.comment-content')
    content_field.css 'overflow', 'hidden'
    min_textarea_height = Forms.get_min_textarea_height(content_field)
    content_field.css 'height', min_textarea_height
    $(window).resize ->
      min_textarea_height = Forms.get_min_textarea_height(content_field)
      return
    content_field.on 'input', ->
      Forms.expand_text_area.call this, min_textarea_height
      return
  return

