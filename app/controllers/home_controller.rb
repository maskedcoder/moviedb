class HomeController < ApplicationController
  layout "home"
  def index
    @movies = Movie.order('lastWatched DESC').limit(3)
  end
end
