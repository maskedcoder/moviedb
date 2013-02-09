class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :dvd
      t.date :lastWatched

      t.timestamps
    end
  end
end
