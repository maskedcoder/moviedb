class ActorsController < ApplicationController
  # GET /actors.json
  def index
    @actors = Actor.all

    respond_to do |format|
      format.json { render json: @actors }
    end
  end

  # GET /actors/1.json
  def show
    @actor = Actor.find(params[:id])

    respond_to do |format|
      format.json { render json: @actor }
    end
  end
  
  # POST /actors
  # POST /actors.json
  def create
    @actor = Actor.new(params[:actor])

    respond_to do |format|
      if @actor.save
        format.html { redirect_to @actor, notice: 'Actor was successfully created.' }
        format.json { render json: @actor, status: :created, location: @actor }
      else
        format.html { render action: "new" }
        format.json { render json: @actor.errors, status: :unprocessable_entity }
      end
    end
  end
end