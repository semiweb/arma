class @Installation
  @collapse: (o) ->
    o.slideUp(100).removeClass 'toggle'

  @expand: (appDiv, content) ->
    appDiv.find('.loader').hide()
    o = App.findInstallations appDiv
    o.html(content).addClass('toggle').slideDown 200

