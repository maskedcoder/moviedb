module MoviesHelper
  attr_accessor :url
  attr_accessor :has_querystring
  def setupURL(url)
    @url = url ? url : ""
    if @url != ""
      @url.gsub! "%5B", "["
      @url.gsub! "%5D", "]"
      @url.gsub! "%20", " "
      @url.gsub! "+", " "
    end
    @has_querystring = @url["?"] == "?"
  end
  def searchURL(category, value)
    "?q="
  end
  def cleanURL(url)
    url.sub! "&&", "&"
    url.sub! "?&", "?"
    url.sub!(/\&$/, "")
    return url
  end
  def removeFilter(category, value)
    filter = Regexp.new "#{category}(\\[\\d?\\])?=#{value}"
    newurl = @url.sub filter, ""
    return cleanURL newurl
  end
  def addFilter(category, value, update=false)
    newurl = @url
    r = Regexp.new("(?<=#{category}=)\\w+")
    if update
      if newurl[r]
        newurl[r] = value
        return newurl
      end
    end
    if @has_querystring
      return newurl+"&#{category}=#{value}"
    end
    return newurl+"?#{category}=#{value}"
  end
  def hasFilter(category, value)
    r = Regexp.new("#{category}(\\[\\d?\\])?=#{value}")
    return @url[r]
  end
  def filterValue(category)
    r = Regexp.new("#{category}(\\[\\d?\\])?=(?<value>.*?(?=($|&)))")
    match = r.match(@url)
    if match
      match = match[:value]
    end
    return match == "" ? "" : match
  end
end
