@Forms =
  expand_input_field: ->
    parent_container = @parentNode
    font_size = window.getComputedStyle(this, null).getPropertyValue('font-size')
    font_size = parseInt(font_size)
    value_length_in_px = (@value.length + 1) * font_size / 2
    if value_length_in_px > parseInt(parent_container.offsetWidth)
      @style.width = parent_container.offsetWidth + 'px'
    else if @value.length > @placeholder.length - 1
      @style.width = (@value.length + 1) * font_size / 2 + 'px'
    else
      @style.width = @placeholder.length * font_size / 2 + 'px'
    return

  expand_text_area: (min_height) ->
    @style.height = 0
    if parseInt(@scrollHeight) < min_height
      @style.height = min_height + 'px'
    else
      @style.height = @scrollHeight + 'px'
    return

  get_min_textarea_height: (jq_identifier) ->
    jq_identifier.css 'height', '0'
    min_height = $('main').height() - $('main article').height() - $('.push').height()
    if jq_identifier[0].scrollHeight > min_height
      jq_identifier.css 'height', jq_identifier[0].scrollHeight
    else
      jq_identifier.css 'height', min_height
    min_height

