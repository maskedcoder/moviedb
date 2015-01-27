class AddReferenceNumberToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :referenceNumber, :string
  end
end
