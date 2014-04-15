#################################
####### CELTICS SCORE ###########
#################################
require 'open-uri'

nba_url = 'http://sports.espn.go.com/nba/bottomline/scores'

nba_scores = open(nba_url) { |io| data = io.read}
nba_scores.gsub!(/%20/, ' ')
$celtics_game = nil
$celtics_message = nil
$celtics_outcome = nil

nba_scores.scan(nba_scores).each do |match| 
    scores = match.scan(/(([\^][[:upper:]]|[[:upper:]][[:lower:]])[^\(&]{1,})/)
    scores.each do |score|
      if score[0] =~ /Boston/
        $celtics_game = score[0]
      end
    end
end

if $celtics_game
  game_position = nba_scores =~ /Boston/
  game_status = nba_scores[game_position..game_position+50].match(/[\(][^\)]{1,}/).to_s
  game_status.gsub!(/\(/, '')
  if game_status.match(/PM|AM/)
    $celtics_message = "The Celtics play at #{game_status}."
    $celtics_outcome = 'pending'
  elsif game_status.match(/FINAL/)
    if $celtics_game.match(/\^Boston/)
      $celtics_message = 'The Celtics won!'
      $celtics_outcome = 'W'
    else
      $celtics_message = 'The Celtics lost.'
      $celtics_outcome = 'L'
    end
  else
    $celtics_message = "The Celtics game is in progress: #{$celtics_game} - #{game_status}"
    $celtics_outcome = 'pending'
  end
else
  $celtics_message = 'No Celtics game.'
  $celtics_outcome = 'N/A'
end

#puts nba_scores