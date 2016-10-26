class @App
  @lunr = lunr(->
    this.field('name', {boost: 10})
    this.field('sha', {boost: 20})
    this.field('branch')
    this.field('env')
    this.ref('id')
  )
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
  @reload_lunr: ->
    @lunr = lunr(->
      this.field('name', {boost: 10})
      this.field('sha', {boost: 20})
      this.field('branch')
      this.field('env')
      this.ref('id')
    )
  @add_indexes_to_lunr: ->
    $('[data-lunr-index]').each (index, element) =>
      @lunr.add({
        id: $(element).attr('data-lunr-index'),
        branch: $(element).attr('data-lunr-branch'),
        sha: $(element).attr('data-lunr-sha'),
        name: $(element).attr('data-lunr-name'),
        env: $(element).attr('data-lunr-env')
      })
  @apply_odd_even_classes: ->
    $(".installation:visible").each (index, element) ->
      $(element).removeClass('odd').removeClass('even')
      if index % 2 != 0
        $(element).addClass('even')
      else
        $(element).addClass('odd')

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

  clipboard = new Clipboard('[data-clipboard-link]');

  $(".reload").click (e) ->
    e.preventDefault();
    e.stopPropagation();
    button = $(this)
    button.addClass('play')
    callback = (data) ->
      button.removeClass('play')
      $("#lunr_search").trigger('keyup')

    $.get button.parents('.app-link').attr('href'),  callback

  $("#lunr_search").on 'keyup', (e) ->
    val = $("#lunr_search").val()

    if App.lunr.documentStore.length >= 1
      search_result = App.lunr.search(val);
      if val == ''
        console.log('show all')
        $('[data-lunr-index]').show()
      else if search_result.length == 0
        console.log('show no results')
      else
        $('[data-lunr-index]').hide()
        $.each search_result, (index, result) ->
          ref_id = result.ref
          $('[data-lunr-index="'+ref_id+'"]').show()
      App.apply_odd_even_classes()
