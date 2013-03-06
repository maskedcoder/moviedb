# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  if $("body").data("controller") in ["movies", "genres", "actors"]
    # Multiselect for movie index, to filter movies by one or more actors
    $("select#actor").multiselect(
      selectedList: false,
      noneSelectedText: "Select actors",
      selectedText: "# actors selected"
    ).multiselectfilter()
    # Toggle the filter controls
    $("#filters-toggle").click( ->
      $("#new-filters").toggle("blind")
    )
    # Searchbar with autocomplete for movies, actors, and genres (seperately)
    $("#searchbar").autocomplete(
      source: (request, response) ->
        $.getJSON(location.pathname.replace(/\/$/, "") + ".json", (rawdata) ->
          matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i")
          data = []
          for obj in rawdata
            label = obj.title || obj.name || obj.firstname + " " + obj.lastname
            data.push({"label": label, "value": obj.id})
          response($.grep(data, (el, index) ->
            return matcher.test(el.label)
            ))
          )
      select: (event, ui)->
        if ui.item
          event.preventDefault()
          $(this).autocomplete("close")
          $(this).val(ui.item.label)
          location.href += "/"+ui.item.value
    )
    # Date control
    $(".date").datepicker({dateFormat: "yy-mm-dd", defaultValue: $(this).val()})
    # Helper function for inserting html representing actors
    logActor = (name, val) ->
      #console.log(name)
      $("#actor-list").append($("<li>").text(name).attr("data-id", val).append($("<p class=\"delete-actor\">").button(
        icons: 
          primary: "ui-icon\-closethick"
        text: false
      ).click( ->
        $(this).parent().remove()
        $("option.actor[value="+val+"]").remove())))
      $("#movie_actors").append("<option class=\"actor\" selected=\"true\" value=\"" + val + "\">" + name + "</option>")
    # Button to remove actor's from the movie's list
    $(".delete-actor").button(
        icons: 
          primary: "ui-icon\-closethick"
        text: false
      ).click( ->
        id = $(this).parent().attr("data-id")
        $(this).parent().remove()
        $("option.actor[value="+id+"]").remove())
    # Autocomplete box for adding actors to the movie's list
    $(".actor-picker").autocomplete(
      source: (request, response) ->
        $.getJSON("/actors.json", (rawdata) ->
          matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i")
          data = []
          for obj in rawdata
            data.push({"label": obj.firstname + " " + obj.lastname, "value": obj.id})
          response($.grep(data, (el, index) ->
            return matcher.test(el.label)
            ))
          )
      select: (event, ui)->
        if ui.item && ($("option.actor[value=" + ui.item.value + "]").length == 0)
          logActor(ui.item.label, ui.item.value)
          event.preventDefault()
          $(this).autocomplete("close")
          $(this).val("")
      response: (event, ui) ->
        if ui.content.length == 0
          strg = this.value
          length = strg.length
          idex = strg.lastIndexOf " " # seperates firstname and lastname based on last space
          fname = strg.substr(0, idex)
          lname = strg.substr(idex+1, length - idex - 1)
          $("#create-new-actor").show().text("Create " + this.value).attr("data-firstname", fname).attr("data-lastname", lname)
        else
          $("#create-new-actor").hide()
    )
    # Button for adding new actor to the database
    $("#create-new-actor").click( ->
      firstname = $(this).attr("data-firstname")
      lastname = $(this).attr("data-lastname")
      $.ajax(
        url: "/actors.json",
        type: "POST",
        data: 
          "actor[firstname]": firstname,
          "actor[lastname]": lastname,
        success: (a,b,c,d) -> 
          logActor(firstname + " " + lastname, a.id)
          $("#create-new-actor").hide()
        failure: (a,b,c,d) ->
          alert "Failure"
          console.log(a, b, c, d)
        )
      )
      
    # Helper function
    logGenre = (name, val) ->
      #console.log(name)
      $("#genre-list").append($("<li>").text(name).attr("data-id", val).append($("<p class=\"delete-genre\">").button(
        icons: 
          primary: "ui-icon\-closethick"
        text: false
      ).click( ->
        $(this).parent().remove()
        $("option.genre[value="+val+"]").remove())))
      $("#movie_genres").append("<option class=\"genre\" selected=\"true\" value=\"" + val + "\">" + name + "</option>")
    # Icon button for removing genre tag from movie
    $(".delete-genre").button(
        icons: 
          primary: "ui-icon\-closethick"
        text: false
      ).click( ->
        id = $(this).parent().attr("data-id")
        $(this).parent().remove()
        $("option.genre[value="+id+"]").remove())
    # Autocomlete box for adding genre tags
    $(".genre-picker").autocomplete(
      source: (request, response) ->
        $.getJSON("/genres.json", (rawdata) ->
          matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i")
          data = []
          for obj in rawdata
            data.push({"label": obj.name, "value": obj.id})
          response($.grep(data, (el, index) ->
            return matcher.test(el.label)
            ))
          )
      minLength: 2,
      select: (event, ui)->
        if ui.item && ($("option.genre[value=" + ui.item.value + "]").length == 0)
          logGenre(ui.item.label, ui.item.value)
          event.preventDefault()
          $(this).autocomplete("close")
          $(this).val("")
      response: (event, ui) ->
        if ui.content.length == 0
          name = this.value
          $("#create-new-genre").show().text("Create genre " + this.value).attr("data-name", name)
        else
          $("#create-new-genre").hide()
    )
    # Button for adding a new genre to the database
    $("#create-new-genre").click( ->
      name = $(this).attr("data-name")
      $.ajax(
        url: "/genres.json",
        type: "POST",
        data: 
          "genre[name]": name,
        success: (a,b,c,d) -> 
          logGenre(name, a.id)
          $("#create-new-genre").hide()
        failure: (a,b,c,d) ->
          alert "Failure"
          console.log(a, b, c, d)
        )
      )
      
  # Control for adding a viewing date to the movie 
  if $("body").data("action") == "show"
    convertDateFormat = (date) ->
      month = date.getMonth() + 1
      year = String(date.getFullYear())
      day = date.getDate()
      m = if (month < 10) then "0"+month else month
      y = year.slice(2,4)
      d = if (day < 10) then "0"+day else day
      return year+"-"+m+"-"+d
    submitView = (date) ->
      date = convertDateFormat(date)
      $("#view_when").val(date)
      $("#new_view").submit()
    $( "#view" )
      .button()
      .click( ->
        submitView(new Date())
      ).next()
        .button(
          text: false,
          icons: 
            primary: "ui-icon-triangle-1-s"
        )
        .click( ->
          menu = $( this ).parent().next().toggle().position(
            my: "left top",
            at: "left bottom",
            of: this
          )
          return false
        ).parent()
          .buttonset()
          .next()
            .hide()
      .datepicker(
        onSelect: ->
          $(this).hide();
          submitView($(this).datepicker("getDate"))
      );
      
  # Implements button to fetch data for the movie from imdbdata.org
  if $("body").data("controller") == "movies"
    $("#movie_title").change((event) ->
        $("#fetch-imdb-data").button("option", "label", "Fetch data for " + event.target.value)
     )
    $("#fetch-imdb-data")
      .button("option", "label", "Fetch data for " + $("#movie_title").val())
      .click( ->
          title = $("#movie_title").val().replace(/\s/g, "+")
          title = title.replace(/!/g, "")
          if not title
            return
          $.getJSON("http://imdbapi.org/?title="+title+"&type=json&limit=6", (a, b, c) ->
              if $("#accordion").hasClass("ui-accordion")
                $("#accordion").accordion("destroy")
                $("#accordion").empty()
              for data in a
                if data.type not in ["M", "TVM"]
                  continue
                if data.runtime == undefined or data.directors == undefined
                  continue
                $("<h3>").text(data.title).appendTo($("#accordion"))
                $container = $("<div><p></p></div>")
                $("<a>").text("Direct link").attr("href", data.imdb_url).appendTo($container)
                $("<p>").text("Title: "+data.title).appendTo($container)
                $("<p>").text("Year: "+data.year).appendTo($container)
                $("<p>").text("Runtime:").appendTo($container)
                $runtime = $("<ul>")
                for time in data.runtime
                  $("<li>"+time+"</li>").appendTo($runtime)
                $runtime.appendTo($container)
                $("<p>").text("Directors:").appendTo($container)
                $directors = $("<ul>")
                for director in data.directors
                  $("<li>"+director+"</li>").appendTo($directors)
                $directors.appendTo($container)
                $("<p>Actors:</p>").appendTo($container)
                $actors = $("<ul>")
                $genres = $("<ul>")
                for actor in data.actors
                  $("<li>"+actor+"</li>").appendTo($actors)
                $actors.appendTo($container)
                $("<p>Genres:</p>").appendTo($container)
                for genre in data.genres
                  $("<li>"+genre+"</li>").appendTo($genres)
                $genres.appendTo($container)
                $container.appendTo($("#accordion"))
              $("#accordion").accordion()
            )
        )
        if $("body").data("controller") == "views"
          date = new Date()
          y = date.getFullYear()
          m = date.getMonth()
          d = date.getDate()
          $("#calendar").fullCalendar(
            events: view_data)

