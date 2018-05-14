# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

resize_thumbnail = (container_identifier, img_identifier) ->
  thumbnail = $(container_identifier)
  thumbnail.css 'height', "#{parseInt(thumbnail.css('width')) / 3}px"
  return

$(window).resize (e) ->
  resize_thumbnail '#thumbnail-container'
  return

$('#article_thumbnail').bind 'change', (e) ->
  size_in_megabytes = @files[0].size/1024/1024
  if size_in_megabytes > 5
    alert 'Maximum file size is 5MB. Please, choose a smaller file.'
  return

$(document).on 'turbolinks:load', ->
  resize_thumbnail '#thumbnail-container'
  return

