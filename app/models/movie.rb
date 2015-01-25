class Movie < ActiveRecord::Base
  attr_accessible :lastWatched, :title, :dvd, :duration, :year, :actors, :genres
  
  validates :title, :presence => true
  
  has_many :actors_movies, :dependent => :destroy
  has_many :actors, :through => :actors_movies
  has_many :genres_movies, :dependent => :destroy
  has_many :genres, :through => :genres_movies
  has_many :directors_movies, :dependent => :destroy
  has_many :directors, :through => :directors_movies
  
  has_many :views, :dependent => :destroy
  
  # Outputs the release year inside parentheses
  def yearstring
    if year
      "(#{year})"
    end
  end
  
  def times_viewed
    views.count
  end
  
  def last_watched
    if views.count == 0
      return false
    end
    recent = views[0]
    views.each do |view|
      if recent[:when] < view[:when]
        recent = view 
      end
    end
    return recent
  end
  
  def display_name
    r = Regexp.new(", ([Tt]he|[Aa]n|[Aa])$")
    if title[r]
      return r.match(title)[1] + " " + title.sub(r, "")
    end
    return title
  end
  
  def displayLastWatched
    return lastWatched.strftime("%B %-d, %Y")
  end
  
  def self.search(q, sort, filters)
    if sort == "alphabetical"
      movies = Movie.order(:title)
    elsif sort == "date"
      movies = Movie.order('lastWatched DESC')
    elsif sort == "type"
      movies = Movie.order(:dvd)
    elsif sort == "duration"
      movies = Movie.order(:duration)
    elsif sort == "year"
      movies = Movie.order(:year)
    end
    
    sortables = {"alphabetical" => :title,
              "title" => :title,
              nil => :title,
              "date" => 'lastWatched DESC',
              "lastWatched" => 'lastWatched DESC',
              "recent" => 'lastWatched DESC',
              "last_watched" => 'lastWatched DESC',
              "type" => :dvd,
              "dvd" => :dvd,
              "release" => :year,
              "year" => :year,
              "time" => :duration,
              "duration" => :duration}
    times = {"short" => (0..60),
              "normal" => (60..90),
              "long" => (90..120),
              "epic" => (120..400)}
    movies = Movie.includes([:actors, :genres]).order(sortables[sort])
    nmovies = []
    movies.each { |movie| nmovies.push movie }
    filters.each do |filter|
      name = filter[:name]
      value = filter[:value]
      if name == "actor"
        if value.kind_of? String
          nmovies.keep_if {|movie| movie.actors.index {|actor| actor.firstname + " " + actor.lastname == value}}
        elsif value.kind_of? Array
         value.each {|val| nmovies.keep_if {|movie| movie.actors.index {|actor| actor.firstname + " " + actor.lastname == val }}}
        else
          value.each {|i, val| nmovies.keep_if {|movie| movie.actors.index {|actor| actor.firstname + " " + actor.lastname == val }}}
        end
      elsif name == "director"
        if value.kind_of? String
          nmovies.keep_if {|movie| movie.directors.index {|director| director.firstname + " " + director.lastname == value}}
        elsif value.kind_of? Array
         value.each {|val| nmovies.keep_if {|movie| movie.directors.index {|director| director.firstname + " " + director.lastname == val }}}
        else
          value.each {|i, val| nmovies.keep_if {|movie| movie.directors.index {|director| director.firstname + " " + director.lastname == val }}}
        end
      elsif name == "genre"
        nmovies.keep_if {|movie| movie.genres.index {|genre| genre.name == value}}
      elsif sortables[name] == :year
        nmovies.keep_if {|movie| movie.year == value.to_i }
      elsif sortables[name] == :dvd
        nmovies.keep_if {|movie| movie.dvd.to_s == value }
      elsif sortables[name] == :duration
        nmovies.keep_if {|movie| times[value].include? movie.duration }
      end
    end
    if q
      nmovies.keep_if {|movie| movie.title.downcase =~ Regexp.new(Regexp.escape(q.downcase))}
    end
    return nmovies
  end
end
