class Movie < ActiveRecord::Base
  attr_accessible :lastWatched, :title, :dvd, :actors, :genres
  
  validates :title, :presence => true
  validates :dvd,  :presence => true
  
  #has_and_belongs_to_many :actors
  #has_and_belongs_to_many :genres
  has_many :actors_movies, :dependent => :destroy
  has_many :actors, :through => :actors_movies
  has_many :genres_movies, :dependent => :destroy
  has_many :genres, :through => :genres_movies
end
