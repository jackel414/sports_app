require 'sinatra'

get '/' do
  @title = 'Home'
	erb :index
end