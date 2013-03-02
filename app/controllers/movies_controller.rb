class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.json
  def index
    @filters = []
    params.each do |key, value|
      if key != "q" and key != "sort" and key != "action" and key != "controller" and value != ""
        if value.kind_of? Array
          value.each {|val| @filters.push({:name => key, :value => val})}
          next
        end
        @filters.push({:name => key, :value => value})
      end
    end
    
    @actors = []
    Actor.order(:lastname, :firstname).each {|actor| @actors.push(actor.name)}
    
    @genres = [""]
    Genre.order(:name).each {|genre| @genres.push(genre.name)}
    
    @movies = Movie.search(params[:q], params[:sort], @filters)
    
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
