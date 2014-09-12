require 'open-uri'
require 'net/http'
require 'rexml/document'
include REXML

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

def patriots_status()
  url = 'http://www.nfl.com/liveupdate/scorestrip/ss.xml'

  # get the XML data as a string
  xml_data = Net::HTTP.get_response(URI.parse(url)).body

  # extract event information
  xmldoc = REXML::Document.new(xml_data)

  @time = Time.new
  @todays_date = @time.strftime("%Y%m%d")
  team_message = nil
  team_outcome = nil
  team_update = []

  xmldoc.elements.each("ss/gms/g") do |e| 
    if e.attributes['h'] == 'NE' || e.attributes['v'] == 'NE'
      game_date = e.attributes['eid'].to_s[0...-2]
      home_score = e.attributes['hs']
      visitor_score = e.attributes['vs']
      if @game_date === @todays_date
        if e.attributes['q'] === 'P'
          team_message = 'The Patriots play at ' + e.attributes['t'] + '.'
          team_outcome = 'pending'
        elsif e.attributes['f'] === 'F'
          if e.attributes['h'] === 'NE'
            if home_score > visitor_score
              team_message = 'The Patriots won!'
              team_outcome = 'W'
            else
              team_message = 'The Patriots lost.'
              team_outcome = 'L'
            end
          end
        else
          if e.attributes['h'] === 'NE'
            visiting_team = e.attributes['v']
            team_message = "In Progress - NE #{home_score}  #{visiting_team} #{visitor_score}."
          else
            home_team = e.attributes['h']
            team_message = "In Progress - NE #{visitor_score}  #{home_team} #{home_score}."
          end
        end
      else
        team_message = 'No Patriots game.'
        team_outcome = 'N/A'
      end
      break
    else
      team_message = 'No Patriots game.'
      team_outcome = 'N/A'
    end
  end
  team_update << team_message
  team_update << team_outcome
end

