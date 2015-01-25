class DirectorsMovie < ActiveRecord::Base
  attr_accessible :director_id, :movie_id
  belongs_to :director
  belongs_to :movie
end
