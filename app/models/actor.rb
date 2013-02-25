class Actor < ActiveRecord::Base
  attr_accessible :firstname, :lastname
  
  validates :lastname, :presence => true
  
  has_many :actors_movies, :dependent => :destroy
  has_many :movies, :through => :actors_movies
  
  # Outputs the actor's name in the format 'firstname lastname'
  def name
    "#{firstname} #{lastname}"
  end
end
