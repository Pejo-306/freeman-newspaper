@Colors =
  # TODO: include the proper universal colors
  universal_colors: [
    '#ff3300', '#b32400', '#ff704d', # red
    '#0080ff', '#0059b3', '#4da6ff', # blue
    '#33cc33', '#70db70', '#248f24', # green
    '#c33cbf', '#d576d2', '#892a85', # magenta
    '#ff8000', '#ffa64d', '#b35900'  # orange
  ]

  get_random_color: (colors) ->
    return colors[Math.floor(Math.random() * colors.length)]

  split_rgb_string: (rgb) ->
    rgb.replace(/[^\d,]/g, '').split(',').map((c) -> parseInt(c))

  componentToHex: (c) ->
    hex = c.toString(16)
    if hex.length == 1 then '0' + hex else hex

  rgbToHex: (r, g, b) ->
    '#' + Colors.componentToHex(r) + Colors.componentToHex(g) + Colors.componentToHex(b)

  shadeHexColor: (hex, lum) ->
    # validate hex string
    hex = String(hex).replace(/[^0-9a-f]/gi, '')
    if hex.length < 6
      hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2]
    lum = lum or 0
    # convert to decimal and change luminosity
    rgb = '#'
    i = 0
    while i < 3
      c = parseInt(hex.substr(i * 2, 2), 16)
      c = Math.round(Math.min(Math.max(0, c + c * lum), 255)).toString(16)
      rgb += ('00' + c).substr(c.length)
      i++
    rgb

