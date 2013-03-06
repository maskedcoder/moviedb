class View < ActiveRecord::Base
  belongs_to :movie
  attr_accessible :when
  
  def display
    return self[:when].strftime("%B %-d, %Y")
  end
  
  def title
    return Movie.find(movie_id).display_name
  end
  
  def movie
    return Movie.find(movie_id)
  end
end
