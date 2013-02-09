class ActorsMovie < ActiveRecord::Base
  attr_accessible :actor_id, :movie_id
  belongs_to :actor
  belongs_to :movie
end
