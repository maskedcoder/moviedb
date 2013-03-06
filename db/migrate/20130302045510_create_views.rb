class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.date :when
      t.references :movie

      t.timestamps
    end
    add_index :views, :movie_id
  end
end
