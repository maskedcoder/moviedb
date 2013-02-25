class AddIdToGenresMovies < ActiveRecord::Migration
  def change
    add_column :genres_movies, :id, :primary_key
  end
end
