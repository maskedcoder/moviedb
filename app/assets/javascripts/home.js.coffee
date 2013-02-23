# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $("input[type=submit], button").button()
  if $("body").data("controller") in ["search", "home"]
    $.widget( "custom.catcomplete", $.ui.autocomplete,
      _renderMenu: ( ul, items ) ->  
        that = this
        currentCategory = ""
        $.each( items, ( index, item ) -> 
          if item.category != currentCategory
            ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" )
            currentCategory = item.category;
          
          that._renderItemData( ul, item );
        )
      
    )
    datamovies = $.parseJSON($.ajax(
      dataType: "json",
      url: "/movies.json",
      async: false
    ).responseText)
    dataactors = $.parseJSON($.ajax(
      dataType: "json",
      url: "/actors.json",
      async: false
    ).responseText)
    datagenres = $.parseJSON($.ajax(
      dataType: "json",
      url: "/genres.json",
      async: false
    ).responseText)
    console.log(datamovies)
    data = []
    for movie in datamovies
      data.push(
        label: movie.title
        value: "movies/" + movie.id
        category: "Movies"
      )
    for actor in dataactors
      data.push(
        label: actor.firstname + " " + actor.lastname
        value: "actors/" + actor.id
        category: "Actor"
      )
    for genre in datagenres
      data.push(
        label: genre.name
        value: "genres/" + genre.id
        category: "Genre"
      )
    console.log(datamovies)
    $("#searchbar").catcomplete(
      source: data
      select: (event, ui) ->
        if ui.item
          event.preventDefault()
          $(this).catcomplete("close")
          $(this).val(ui.item.label)
          location.pathname = ui.item.value
    )
