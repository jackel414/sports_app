require 'rubygems'
require 'sinatra'

require 'red_sox_engine'
require 'bruins_engine'
require 'celtics_engine'
require 'patriots_engine'

$overall_status = 'So Far, So Good'

get '/' do
  @title = 'Home'
  @red_sox_update = $red_sox_message
  @bruins_update = $bruins_message
  @celtics_update = $celtics_message
  @patriots_update = $patriots_message
  @overall_status = $overall_status
	erb :index
end