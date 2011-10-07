# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
#


require 'toto'                   #for our toto blog app

#point to your rails apps /public directory so that you can 
#reuse the resources in the public directory
use Rack::Static, :urls => ['/stylesheets', '/javascripts', '/images',
'/favicon.ico'], :root => 'public'

use Rack::ShowExceptions    #so we can debug
use Rack::CommonLogger

#start up the toto application
toto = Toto::Server.new do
  #override the default location for the toto directories point them 
  #at the appropriate location for your blog
  Toto::Paths = {
    :templates => 'blog/templates',
    :pages => 'blog/templates/pages',
    :articles => 'blog/articles'
    }

  #set your config variables here
  set :title, 'Your Blog Title'
  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
  set :summary,   :max => 500
  set :root, 'blog'
  #the following might not be necessary, but for me it was in v0.2.8
  if RAILS_ENV != 'production'
    set :url, "http://localhost:9292/blog/"
  else
    set :url, "http://your-blog.heroku.com/blog/"
  end
end

#create a rack app so we can dispatch requests appropriately
app = Rack::Builder.new do
  use Rack::CommonLogger

  #map requests to /blog to toto.  Change the location if you need to.
  map '/blog' do
    run toto
  end

  #map all the other requests to rails
  map '/' do
   # use Rails::Rack::Static
   # run ActionController::Dispatcher.new


    run PersonalSite::Application
  end
end.to_app

#start the rack app
run app
