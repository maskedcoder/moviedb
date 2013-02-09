class GenresController < ApplicationController
  # GET /genres.json
  def index
    @genres = Genre.all

    respond_to do |format|
      format.json { render json: @genres }
    end
  end

  # GET /genres/1.json
  def show
    @genre = Genre.find(params[:id])

    respond_to do |format|
      format.json { render json: @genre }
    end
  end
  
  # POST /genres
  # POST /genres.json
  def create
    @genre = Genre.new(params[:genre])

    respond_to do |format|
      if @genre.save
        format.html { redirect_to @genre, notice: 'Genre was successfully created.' }
        format.json { render json: @genre, status: :created, location: @genre }
      else
        format.html { render action: "new" }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end
end