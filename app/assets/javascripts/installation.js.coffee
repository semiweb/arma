class @Installation
  @handleExpandLink: (link) ->
    states = @findStates link
    states.slideToggle 150, ->
      states.toggleClass 'toggle'

  @findStates: (o) ->
    installDiv = o.closest '.installation'
    installDiv.next '.states'

  @collapse: (o) ->
    o.slideUp(100).removeClass 'toggle'

  @collapseAll: (col) ->
    col.slideUp(100).removeClass 'toggle'

  @expand: (appDiv, content, callback) ->
    appDiv.find('.loader').hide()
    o = App.findInstallations appDiv
    o.html(content).addClass('toggle').slideDown 200, ->
      callback o

