class ViewsController < ApplicationController
  def create
    @movie = Movie.find(params[:movie_id])
    @view = @movie.views.create(params[:view])
    if @view == @movie.last_watched
      @movie.update_attribute(:lastWatched, params[:view][:when])
    end
    redirect_to movie_path(@movie)
  end
  
  def destroy
    @movie = Movie.find(params[:movie_id])
    @view = @movie.views.find(params[:id])
    @view.destroy
    @movie.update_attribute(:lastWatched, (@movie.last_watched) ? @movie.last_watched[:when] : nil)
    redirect_to movie_path(@movie)
  end
end
