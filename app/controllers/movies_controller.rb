class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.json
  def index
    if params[:sort]
      if params[:sort] == "alphabetical"
        @movies = Movie.order(:title)
      elsif params[:sort] == "date"
        @movies = Movie.order('lastWatched DESC')
      elsif params[:sort] == "type"
        @movies = Movie.order(:dvd)
      elsif params[:sort] == "duration"
        @movies = Movie.order(:duration)
      elsif params[:sort] == "year"
        @movies = Movie.order(:year)
      end
    else
      @movies = Movie.order(:title)
    end
    
    if params[:q]
      @movies.keep_if {|movie| movie.title =~ Regexp.new(Regexp.escape(params[:q]))}
    end
    
    if params[:limit]
      @movies = @movies.limit(params[:limit])
    end
    
    @search = params[:q] || ""

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.json
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    if params[:movie][:actors]
      params[:movie][:actors].map!{ |id|
        Actor.find(id)
        }
    else
      params[:movie][:actors] = []
    end
    if params[:movie][:genres]
      params[:movie][:genres].map!{ |id|
        Genre.find(id)
        }
    else
      params[:movie][:genres] = []
    end
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: @movie }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])
    if params[:movie][:actors]
      params[:movie][:actors].map!{ |id|
        Actor.find(id)
        }
    else
      params[:movie][:actors] = []
    end
    if params[:movie][:genres]
      params[:movie][:genres].map!{ |id|
        Genre.find(id)
        }
    else
      params[:movie][:genres] = []
    end

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end
end
