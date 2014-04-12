require 'rubygems'
require 'sinatra'

require 'red_sox_engine'
require 'bruins_engine'
require 'celtics_engine'
require 'patriots_engine'

full_scoreboard = [$red_sox_outcome, $bruins_outcome, $celtics_outcome, $patriots_outcome]
total_games = 0
wins = 0
losses = 0
pending = 0
overall_status = nil

full_scoreboard.each do |score|
  if score != 'N/A'
    total_games += 1
    if score == 'W'
      wins += 1
    elsif score == 'L'
      losses += 1
    else
      pending += 1
    end
  end
end

if total_games == 0
  overall_status = 'No Games Today'
elsif pending == total_games
  overall_status = 'Nothing to Report Yet'
elsif pending == 0
  if total_games == 4
    if wins == 4
      overall_status = 'Mark This Day In History!'
    elsif wins == 3
      overall_status = 'Almost Perfect'
    elsif wins == 2
      overall_status = 'Win some, lose some'
    elsif wins == 1
      overall_status = 'Not good, but could be worse'
    else
      overall_status = 'There are bad days, then there is today...'
    end
  elsif wins == total_games
    overall_status = 'Great day!'
  elsif wins == 0
    overall_status = 'Not good'
  else
    if wins > losses
      overall_status = 'Almost Perfect'
    elsif wins == losses
      overall_status = 'Win some, lose some'
    else
      overall_status = 'Not good, but could be worse'
    end
  end
else
  if losses == 0
    overall_status = 'So far, So Good'
  elsif wins == 0
    overall_status = 'Got Some Work To Do'
  else
    overall_status = 'Mixed Bag So Far'
  end
end

post '/' do
  @title = 'Home'
  @red_sox_update = $red_sox_message
  @bruins_update = $bruins_message
  @celtics_update = $celtics_message
  @patriots_update = $patriots_message
  @overall_status = overall_status
  @pending = pending
  @total_games = total_games
	erb :index
end

get '/' do
  redirect 'http://www.zacharymays.com'
end