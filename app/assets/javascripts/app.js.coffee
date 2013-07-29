class @App
  @handleClick: (o) ->
    installations = @findInstallations o
    if installations.hasClass 'toggle'
      Installation.collapse installations
      return false
    else
      o.find('.loader').show()

  @findInstallations: (o) ->
    o.next '.installations'

$ ->
  $('.app-link').click (e) ->
    App.handleClick $(this)

  $('#applications').on 'click', '.install-link', (e) ->
    Installation.handleClick $(this)
