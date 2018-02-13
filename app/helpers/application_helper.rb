module ApplicationHelper
  require 'net/ping'
  
  #https://stackoverflow.com/questions/2385186/check-if-internet-connection-exists-with-ruby/8317838 - answer by fguillen
  #sample usage - StaticPagesController (dashboard) & dashboard.htm.haml
  def internet_connection?
    Net::Ping::External.new("8.8.8.8").ping?
  end
end
