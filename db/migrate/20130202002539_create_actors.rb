class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.string :firstname
      t.string :lastname
      t.references :movie

      t.timestamps
    end
    add_index :actors, :movie_id
  end
end