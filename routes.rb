require 'rubygems'
require 'sinatra'

require 'engine'


get '/' do
  @title = 'How\'d Our Teams Do?'
  
  total_games = 0
  wins = 0
  losses = 0
  pending = 0
  overall_status = nil
  
  teams = [['Boston', 'Red Sox', 'mlb'], ['Boston', 'Bruins', 'nhl'], ['Boston', 'Celtics', 'nba'], ['New Engalnd', 'Patriots', 'nfl']]
  
  @team_updates = []
  teams.each do |(city, team, sport)|
    team_update = team_status(city, team, sport)
    team_no_space = team.gsub(/\s/, '_')
    @team_updates << {:team_name => team_no_space, :update => team_update[0], :outcome => team_update[1]}
    if team_update[1] != 'N/A'
      total_games += 1
      if team_update[1] == 'W'
        wins += 1
      elsif team_update[1] == 'L'
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
  
  @overall_status = overall_status  
  
	erb :index
end