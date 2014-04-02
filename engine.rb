require 'open-uri'

mlb_url = 'http://sports.espn.go.com/mlb/bottomline/scores'

mlb_scores = open(mlb_url) { |io| data = io.read}
mlb_scores.gsub!(/%20/, ' ')
redsox_status = nil
puts "Enter your team's city:"
team = gets.chomp

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

if redsox_status != 'not today'
  puts "The game is #{redsox_status}. #{message}"
else
  puts message
end

#puts mlb_scores