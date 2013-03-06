class View < ActiveRecord::Base
  belongs_to :movie
  attr_accessible :when
  
  def display
    return self[:when].strftime("%B %-d, %Y")
  end
end
