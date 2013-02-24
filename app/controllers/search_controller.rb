class SearchController < ApplicationController
  # GET /search
  # GET /search.json
  def index
    @movies = Movie.order(:title)
    @actors = Actor.order(:lastname)
    @genres = Genre.order(:name)
    
    if params[:q]
      @movies.keep_if {|movie| movie.title =~ Regexp.new(Regexp.escape(params[:q]))}
      @actors.keep_if {|actor| actor.name =~ Regexp.new(Regexp.escape(params[:q]))}
      @genres.keep_if {|genre| genre.name =~ Regexp.new(Regexp.escape(params[:q]))}
    end
    
    @search = params[:q] || ""
    
    respond_to do |format|
      format.html # search.html.erb
      format.json { render json: @movies + @actors + @genres }
    end
  end
end