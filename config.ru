require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'

require File.expand_path '../routes.rb', __FILE__

set :environment, :development
run Sinatra::Application