module ApplicationHelper
  def back_url
    return session[:back] || "/" + controller_name
  end
end
