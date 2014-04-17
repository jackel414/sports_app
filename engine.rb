require 'open-uri'

def team_status(city, team, sport)

  sport_url = "http://sports.espn.go.com/#{sport}/bottomline/scores"
  
  scores = open(sport_url) { |io| data = io.read }
  scores.gsub!(/%20/, ' ')
  my_game = nil
  team_message = nil
  team_outcome = nil
  team_update = []

  scores.scan(scores).each do |match|
      all_scores = match.scan(/(([\^][[:upper:]]|[[:upper:]][[:lower:]])[^\(&]{1,})/)
      all_scores.each do |score|
        if score[0] =~ /#{city}/
          my_game = score[0]
        end
      end
  end

  if my_game
    game_position = scores =~ /#{city}/
    game_status = scores[game_position..game_position+50].match(/[\(][^\)]{1,}/).to_s
    game_status.gsub!(/\(/, '')
    if game_status.match(/PM|AM/)
      team_message = "The #{team} play at #{game_status}."
      team_outcome = 'pending'
    elsif game_status.match(/FINAL/)
      if my_game.match(/\^#{city}/)
        team_message = "The #{team} won!"
        team_outcome = 'W'
      else
        team_message = "The #{team} lost."
        team_outcome = 'L'
      end
    else
      team_message = "#{my_game} - #{game_status}"
      team_outcome = 'pending'
    end
  else
    team_message = "No #{team} game."
    team_outcome = 'N/A'
  end
  team_update << team_message
  team_update << team_outcome
end

#puts team_status('Bruins', 'Boston', 'nhl')