# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # video recording
  player = videojs('pitch',
    controls: true
    width: 640
    height: 480
    plugins: record:
      audio: true
      video: true
      maxLength: 60
      debug: true)
  player.on 'deviceError', ->
    player.recorder.stopDevice()
    handle_validation('Duh! The following error occured during recording: <br/>' + player.deviceErrorCode)
    return
  player.on 'error', (error) ->
    player.recorder.stopDevice()
    handle_validation('Duh! The following error occured during recording: <br/>' + error)
    return
  # user clicked the record button and started recording
  player.on 'startRecord', ->
    $('.navbar .container .steps-container li').removeClass('active')
    $('.navbar .container .steps-container li.first').addClass('active')
    return
  # user completed recording and stream is available
  player.on 'finishRecord', ->
    $('.navbar .container .steps-container li').addClass('active')
    $('.navbar .container .steps-container li.third').removeClass('active')
    return

  # init fileupload
  $('#fileupload').fileupload
    url: '/upload/'
    done: (e, data) ->
      player.recorder.stopDevice()
      $("html, body").animate({ scrollTop: 0 }, "slow");

      $('.navbar .container .steps-container li').addClass('active')
      $('.record-container').hide()
      $('.done').show()
      return
    progress: (e, data) ->
      $('.input-fields').hide()
      progress = parseInt(data.loaded / data.total * 100, 10);
      $('#send-pitch').text(progress + '% uploaded')
      $('.progress-bar').css('width', progress + '%;')
      return
    error: (jqXHR, textStatus, errorThrown) ->
      player.recorder.stopDevice()
      $("html, body").animate({ scrollTop: 0 }, "slow");

      button = $('#send-pitch')
      button.text('Send us the Pitch!')
      button.prop('disabled', false)

      $('.record-container').hide()
      $('.not-done').show()
      return

  handle_validation = (msg) ->
    validation_modal = $('#validation').modal('show')
    validation_modal.find('.modal-body').html(msg)
    return

  $('#send-pitch').on 'click', (e) ->
    unless player.recordedData
      handle_validation("We couldn't find a valid pitch recording! If you have recorded it and still can't send it to us, please drop us an e-mail at: <b>support@pitchium.com</b>")
      return false
    unless $('input#contact-info') && $('input#contact-info').val().length > 0
      handle_validation("Please write down an E-mail or Skype account so we can get back to you 🤗")
      return false

    console.log('jeje')
    console.log(player.recordedData)
    video = [player.recordedData.video || player.recordedData]
    console.log('jeje2')
    console.log(video)
    $('#fileupload').fileupload('add', {files: [video]});
    e.target.disabled = true
    return

  $('#retry-upload').on 'click', (e) ->
    $('.not-done').hide()
    $('.record-container').show()
    $('.input-fields').show()

$(document).ready(ready)
$(document).on('page:load', ready)
