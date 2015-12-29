# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Moviedb::Application.initialize!

# Open a browser window
# See http://stackoverflow.com/a/14053693
link = "http://localhost:3000"
if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
  system "start #{link}"
elsif RbConfig::CONFIG['host_os'] =~ /darwin/
  system "open #{link}"
elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
  system "xdg-open #{link}"
end
