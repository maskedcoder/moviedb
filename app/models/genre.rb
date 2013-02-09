class Genre < ActiveRecord::Base
  #has_and_belongs_to_many :movies
  attr_accessible :name
  
  has_many :genres_movies, :dependent => :destroy
  has_many :movies, :through => :genres_movies
end
