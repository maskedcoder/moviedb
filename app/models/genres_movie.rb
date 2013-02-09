class GenresMovie < ActiveRecord::Base
  attr_accessible :genre_id, :movie_id
  belongs_to :genre
  belongs_to :movie
end
