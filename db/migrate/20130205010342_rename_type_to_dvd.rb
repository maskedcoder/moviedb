class RenameTypeToDvd < ActiveRecord::Migration
  def up
    rename_column :movies, :type, :dvd
  end

  def down
    rename_column :movies, :dvd, :type
  end
end
