#################################
####### RED SOX SCORE ###########
#################################
require 'open-uri'

mlb_url = 'http://sports.espn.go.com/mlb/bottomline/scores'

mlb_scores = open(mlb_url) { |io| data = io.read}
mlb_scores.gsub!(/%20/, ' ')
red_sox_game = nil
$red_sox_message = nil
$red_sox_outcome = nil
num_games = 0

mlb_scores.scan(mlb_scores).each do |match| 
    scores = match.scan(/(([\^][[:upper:]]|[[:upper:]][[:lower:]])[^\(&]{1,})/)
    scores.each do |score|
      if score[0] =~ /Boston/
        red_sox_game = score[0]
        num_games += 1
      end
    end
end

if red_sox_game
  game_position = mlb_scores =~ /Boston/
  game_status = mlb_scores[game_position..game_position+50].match(/[\(][^\)]{1,}/).to_s
  game_status.gsub!(/\(/, '')
  if game_status.match(/TOP|BOT/)
    $red_sox_message = "The Red Sox game is in progress: #{$red_sox_game} - #{game_status}"
    $red_sox_outcome = 'pending'
  elsif game_status.match(/FINAL/)
    if red_sox_game.match(/\^Boston/)
      $red_sox_message = 'The Red Sox won!'
      $red_sox_outcome = 'W'
    else
      $red_sox_message = 'The Red Sox lost.'
      $red_sox_outcome = 'L'
    end
  else
    $red_sox_message = "The Red Sox play at #{game_status}."
    $red_sox_outcome = 'pending'
  end
else
  $red_sox_message = 'No Red Sox game.'
  $red_sox_outcome = 'N/A'
end

# puts mlb_scores