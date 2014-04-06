#################################
####### BRUINS SCORE ############
#################################
require 'open-uri'

nhl_url = 'http://sports.espn.go.com/nhl/bottomline/scores'

nhl_scores = open(nhl_url) { |io| data = io.read}
nhl_scores.gsub!(/%20/, ' ')
bruins_game = nil
$bruins_message = nil
$bruins_outcome = nil

nhl_scores.scan(nhl_scores).each do |match| 
    scores = match.scan(/(([\^][[:upper:]]|[[:upper:]][[:lower:]])[^\(&]{1,})/)
    scores.each do |score|
      if score[0] =~ /Boston/
        bruins_game = score[0]
      end
    end
end

if bruins_game
  game_position = nhl_scores =~ /Boston/
  game_status = nhl_scores[game_position..game_position+50].match(/[\(][^\)]{1,}/).to_s
  game_status.gsub!(/\(/, '')
  if game_status.match(/PM|AM/)
    $bruins_message = "The Bruins play at #{game_status}."
    $bruins_outcome = 'pending'
  elsif game_status.match(/FINAL/)
    if bruins_game.match(/\^Boston/)
      $bruins_message = 'The Bruins won!'
      $bruins_outcome = 'W'
    else
      $bruins_message = 'The Bruins lost.'
      $bruins_outcome = 'L'
    end
  else
    $bruins_message = "The Bruins game is in progress. #{bruins_game} - #{game_status}"
    $bruins_outcome = 'pending'
  end
else
  $bruins_message = 'The Bruins don\'t play today.'
  $bruins_outcome = 'N/A'
end

#puts nhl_scores