@Colors =
  # TODO: include the proper universal colors
  universal_colors: ['red', 'blue', 'green', 'magenta', 'orange']

  get_random_color: (colors) ->
    return colors[Math.floor(Math.random() * colors.length)]

