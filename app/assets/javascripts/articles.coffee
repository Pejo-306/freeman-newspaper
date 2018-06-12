# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

thumbnail_height = 608

resize_thumbnail = (container_identifier) ->
  thumbnail = $(container_identifier)
  thumbnail.css 'height', "#{parseInt(9 * thumbnail.css('width')) / 16}px"
  return

$(window).resize (e) ->
  resize_thumbnail '.thumbnail-container'
  return

$(document).on 'turbolinks:load', ->
  # thumbnail display and upload
  resize_thumbnail '.thumbnail-container'
  if window.File and window.FileReader and window.FileList and window.Blob
    # file upload
    $('#article_thumbnail').change (e) ->
      for f in @files
        # prevent files larger than 5MB in size to be uploaded
        size_in_megabytes = f.size/1024/1024
        if size_in_megabytes > 5
          alert 'Maximum file size is 5MB. Please, choose a smaller file.'
          return
        
        # open the image file and display its contents
        reader = new FileReader()
        reader.onload = ((file) ->
          # change image label
          $('#thumbnail-filename span').text file.name
          return (e) ->
            $('label[for=article_thumbnail] img').attr 'src', @result
            return
        )(f)
        reader.readAsDataURL f
      return
    
    $('.img-tag-container img').load (e) ->
      label = @parentElement
      # reset margins that have been set by previously loaded images
      @style.marginTop = @style.marginRight = @style.marginBottom = @style.marginLeft = '0px'

      # contain the image within its parent container
      $(label).prepend "<img src=#{@src}>"
      @height = Math.min thumbnail_height, label.firstChild.height
      label.firstChild.remove()

      # set margins to center the image tag
      leftover_width = label.offsetWidth - @offsetWidth
      @style.marginLeft = @style.marginRight = "#{leftover_width / 2}px"
      leftover_height = label.offsetHeight - @offsetHeight
      @style.marginTop = @style.marginBottom = "#{leftover_height / 2}px"
      return
  else
    alert 'The File APIs are not fully supported in this browser.'

  # form style
  if $('form.new_article').exists() or $('form.edit_article').exists()
    $('#title-field').on 'input', Forms.expand_input_field

    content_field = $('#content-field')
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

