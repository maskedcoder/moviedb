class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :log_back_url, :only => 'index'
  
  def log_back_url
    if request.format == "html"
      match = /\/\/.*?(\/.*)/.match(request.url)
      session[:back] = match ? match[1] : "/"
    end
  end
end
