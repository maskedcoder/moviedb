class Actor < ActiveRecord::Base
  #has_and_belongs_to_many :movies
  attr_accessible :firstname, :lastname
  
  has_many :actors_movies, :dependent => :destroy
  has_many :movies, :through => :actors_movies
end
