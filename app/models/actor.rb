class Actor < ActiveRecord::Base
  attr_accessible :firstname, :lastname
  
  has_many :actors_movies, :dependent => :destroy
  has_many :movies, :through => :actors_movies
  
  def name
    "#{firstname} #{lastname}"
  end
end
