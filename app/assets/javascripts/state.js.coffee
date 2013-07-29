class @State
  @handleExpandLink: (link) ->
    if link.hasClass 'toggle'
      link.removeClass('toggle').html 'Expand'
      link.next('.expanded').slideUp 100
    else
      link.addClass('toggle').html 'Collapse'
      link.next('.expanded').slideDown 200

  @collapse: (o) ->
    o.slideUp(100).removeClass 'toggle'

  @expand: (installDiv, content = undefined) ->
    installDiv.find('.loader').hide()
    o = Installation.findStates installDiv
    o.html(content) if content?
    o.addClass('toggle').slideDown 200

$ ->
  $('.installations').on 'click', 'a.expand', (e) ->
    e.preventDefault()
    State.handleExpandLink $(this)

