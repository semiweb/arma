class @App
  @handleClick: (o) ->
    installations = @findInstallations o
    if installations.hasClass 'toggle'
      Installation.collapse installations
      return false

  @findInstallations: (o) ->
    o.next '.installations'

$ ->
  $('.app-link').click (e) ->
    App.handleClick $(this)

  $('#applications').on 'click', '.install-link', (e) ->
    Installation.handleClick $(this)
