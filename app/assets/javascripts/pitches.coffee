# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  player = videojs('pitch',
    controls: true
    width: 640
    height: 480
    plugins: record:
      audio: true
      video: true
      maxLength: 60
      debug: true)
  # error handling
  player.on 'deviceError', ->
    console.log 'device error:', player.deviceErrorCode
    return
  player.on 'error', (error) ->
    console.log 'error:', error
    return
  # user clicked the record button and started recording
  player.on 'startRecord', ->
    console.log 'started recording!'
    $('.navbar .container .steps-container li').removeClass('active')
    $('.navbar .container .steps-container li.first').addClass('active')
    return
  # user completed recording and stream is available
  player.on 'finishRecord', ->
    # the blob object contains the recorded data that
    # can be downloaded by the user, stored on server etc.
    $('.navbar .container .steps-container li').addClass('active')
    $('.navbar .container .steps-container li.third').removeClass('active')
    console.log 'finished recording: ', player.recordedData
    return

$(document).ready(ready)
$(document).on('page:load', ready)
