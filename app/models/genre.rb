class Genre < ActiveRecord::Base
  attr_accessible :name
  
  validates :name, :presence => true
  
  has_many :genres_movies, :dependent => :destroy
  has_many :movies, :through => :genres_movies
end
