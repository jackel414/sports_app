require 'open-uri'

mlb_url = 'http://sports.espn.go.com/mlb/bottomline/scores'

mlb_scores = open(mlb_url) { |io| data = io.read}
mlb_scores.gsub!(/%20/, ' ')
redsox_status = nil
# puts "Enter your team's city:"
# team = gets.chomp

=begin
if mlb_scores =~ /#{team}/
  if mlb_scores =~ /#{team} at/ or mlb_scores =~ /at #{team}/
    redsox_status = 'not over'
    if mlb_scores =~ /#{team} at/
      message = "#{team} is away today."
    else
      message = "#{team} is home today."
    end
  elsif mlb_scores =~ /#{team} \d/
    redsox_status = 'over'
    if mlb_scores =~ /\^#{team}/
      message = "#{team} won!"
    else
      message = "#{team} lost."
    end
  end
else
  redsox_status = 'not today'
  message = "#{team} does not play today."
end
=end

=begin
if mlb_scores =~ /#{team}/
  if mlb_scores =~ /(#{team})(?<==)/
    puts 'True'
  else
    puts 'Not there'
  end
end
=end

# (Boston)(?=\s\d) is for a space and then number

=begin
if redsox_status != 'not today'
  puts "The game is #{redsox_status}. #{message}"
else
  puts message
end
=end

red_sox_game = nil
mlb_scores.scan(mlb_scores).each do |match| 
    scores = match.scan(/((?<==)([\^][[:upper:]]|[[:upper:]][[:lower:]])[^\(&]{1,})/)
    scores.each do |score|
      if score[0] =~ /Boston/
        red_sox_game = score[0]
      end
    end
end

puts red_sox_game
game_position = mlb_scores =~ /#{red_sox_game}/
game_status = mlb_scores[game_position..game_position+50].match(/(?<=\()[^\)]{1,}/)
puts game_status

