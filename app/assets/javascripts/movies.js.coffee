# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  if $("body").data("controller") in ["movies", "genres", "actors"]
    $("#searchbar").autocomplete(
      source: (request, response) ->
        $.getJSON(location.pathname + ".json", (rawdata) ->
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
    $(".date").datepicker({dateFormat: "yy-mm-dd", defaultValue: $(this).val()})
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
    $(".delete-actor").button(
        icons: 
          primary: "ui-icon\-closethick"
        text: false
      ).click( ->
        id = $(this).parent().attr("data-id")
        $(this).parent().remove()
        $("option.actor[value="+id+"]").remove())
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
          idex = strg.lastIndexOf " "
          fname = strg.substr(0, idex)
          lname = strg.substr(idex+1, length - idex - 1)
          $("#create-new-actor").show().text("Create " + this.value).attr("data-firstname", fname).attr("data-lastname", lname)
        else
          $("#create-new-actor").hide()
    )
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
    $(".delete-genre").button(
        icons: 
          primary: "ui-icon\-closethick"
        text: false
      ).click( ->
        id = $(this).parent().attr("data-id")
        $(this).parent().remove()
        $("option.genre[value="+id+"]").remove())
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
  if $("body").data("controller") == "movies"
    $("#movie_title").change((event) ->
        $("#fetch-imdb-data").button("option", "label", "Fetch data for " + event.target.value)
     )
    $("#fetch-imdb-data")
      .button("option", "label", "Fetch data for " + $("#movie_title").val())
      .click( ->
          title = $("#movie_title").val().replace(/\s/g, "+")
          if not title
            return
          $.getJSON("http://imdbapi.org/?title="+title+"&type=json", (a, b, c) ->
              data = a[0]
              $("#imdb-title").text("Title: "+data.title)
              $("#imdb-year").text("Year: "+data.year)
              $("#imdb-runtime").text("Runtime: "+data.runtime[0])
              $("#imdb-actors").empty().before("<p>Actors:</p>")
              $("#imdb-genres").empty().before("<p>Genres:</p>")
              $("#imdb-link").text("Direct link").attr("href", data.imdb_url)
              for actor in data.actors
                $("#imdb-actors").append("<li>"+actor+"</li>")
              for genre in data.genres
                $("#imdb-genres").append("<li>"+genre+"</li>")
            )
        )
