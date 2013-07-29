class @Installation
  @handleClick: (o) ->
    states = @findStates o
    if states.hasClass 'toggle'
      State.collapse states
      return false
    else
      o.find('.loader').show()

  @findStates: (o) ->
    o.next '.states'

  @collapse: (o) ->
    o.slideUp(100).removeClass 'toggle'

  @collapseAll: (col) ->
    col.slideUp(100).removeClass 'toggle'

  @expand: (appDiv, content, callback) ->
    appDiv.find('.loader').hide()
    o = App.findInstallations appDiv
    o.html(content).addClass('toggle').slideDown 200, ->
      callback o

