class @App
  @handleClick: (o) ->
    installations = @findInstallations o
    if installations.hasClass 'toggle'
      Installation.collapse installations
      o.find('.reload').hide()
      return false
    else
      o.find('.loader').show()

  @findInstallations: (o) ->
    o.next '.installations'

  @tablesort: (table) ->
    base_opts = {headers:{},widgets: ['zebra'] }
    t = table.find('[data-sorted="false"]')
    put_index_in_header = (el) -> base_opts.headers[$(el).index()] = {sorter:false}
    put_index_in_header elem for elem in t

    table.tablesorter(base_opts);

$ ->
  $('.app-link').click (e) ->
    App.handleClick $(this)

  $('#generateChangelog').click (e) ->
    e.preventDefault()
    $("#changelogs form").submit()

  if $(".tablesorter").length > 0
    App.tablesort($(".tablesorter"))

  if $(".installations.toggle").length > 0
    $(".installations.toggle").prev(".app-link").find('.reload').show()

  $(".reload").click (e) ->
    e.preventDefault();
    e.stopPropagation();
    button = $(this)
    button.addClass('play')
    callback = (data) ->
      button.removeClass('play')

    $.get button.parents('.app-link').attr('href'),  callback