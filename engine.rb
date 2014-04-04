require 'open-uri'

mlb_url = 'http://sports.espn.go.com/mlb/bottomline/scores'

mlb_scores = open(mlb_url) { |io| data = io.read}
mlb_scores.gsub!(/%20/, ' ')
red_sox_game = nil
message = nil
red_sox_outcome = nil
num_games = 0

mlb_scores.scan(mlb_scores).each do |match| 
    scores = match.scan(/((?<==)([\^][[:upper:]]|[[:upper:]][[:lower:]])[^\(&]{1,})/)
    scores.each do |score|
      if score[0] =~ /Boston/
        red_sox_game = score[0]
        num_games += 1
      end
    end
end

game_position = mlb_scores =~ /#{red_sox_game}/
game_status = mlb_scores[game_position..game_position+50].match(/(?<=\()[^\)]{1,}/).to_s

if red_sox_game
  if game_status.match(/TOP|BOT/)
    message = 'The game is in progress.'
    red_sox_outcome = 'pending'
  elsif game_status.match(/FINAL/)
    if red_sox_game.match(/\^Boston/)
      message = 'The Red Sox won!'
      red_sox_outcome = 'win'
    else
      message = 'The Red Sox lost.'
      red_sox_outcome = 'lost'
    end
  else
    message = 'The Red Sox game hasn\'t started yet.'
    red_sox_outcome = 'later'
  end
else
  message = 'The Red Sox don\'t play today.'
end

if red_sox_outcome == 'later'
  puts "The Red Sox play at #{game_status}."
elsif red_sox_outcome == 'pending'
  puts "#{message} #{red_sox_game} - #{game_status}"
else
  puts "#{message}"
end


#puts mlb_scores
