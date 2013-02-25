class AddIdToActorsMovies < ActiveRecord::Migration
  def change
    add_column :actors_movies, :id, :primary_key
  end
end
