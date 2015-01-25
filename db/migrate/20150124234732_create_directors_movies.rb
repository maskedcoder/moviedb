class CreateDirectorsMovies < ActiveRecord::Migration
  def change
    create_table :directors_movies do |t|
      t.integer :director_id
      t.integer :movie_id
    end
  end
end
