#################################
####### PATRIOTS SCORE ##########
#################################
require 'open-uri'

def patriots_score
  nfl_url = 'http://sports.espn.go.com/nfl/bottomline/scores'

  nfl_scores = open(nfl_url) { |io| data = io.read}
  nfl_scores.gsub!(/%20/, ' ')
  $patriots_game = nil
  $patriots_message = nil
  $patriots_outcome = nil

  nfl_scores.scan(nfl_scores).each do |match| 
      scores = match.scan(/(([\^][[:upper:]]|[[:upper:]][[:lower:]])[^\(&]{1,})/)
      scores.each do |score|
        if score[0] =~ /New England/
          $patriots_game = score[0]
        end
      end
  end

  if $patriots_game
    game_position = nfl_scores =~ /New England/
    game_status = nfl_scores[game_position..game_position+50].match(/[\(][^\)]{1,}/).to_s
    game_status.gsub!(/\(/, '')
    if game_status.match(/PM|AM/)
      $patriots_message = "The Patriots play at #{game_status}."
      $patriots_outcome = 'pending'
    elsif game_status.match(/FINAL/)
      if $patriots_game.match(/\^New England/)
        $patriots_message = 'The Patriots won!'
        $patriots_outcome = 'W'
      else
        $patriots_message = 'The Patriots lost.'
        $patriots_outcome = 'L'
      end
    else
      $patriots_message = "#{$patriots_game} - #{game_status}"
      $patriots_outcome = 'pending'
    end
  else
    $patriots_message = 'No Patriots game.'
    $patriots_outcome = 'N/A'
  end
end

#puts nfl_scores