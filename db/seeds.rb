# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['casadamusica', 'ColiseuPorto', 'fundacaoserralves', 'ClubRivoliPorto', 'contagiarte', 'HardClubPorto'].each { |landmark_username|
    
  url = FB_GRAPH_API + '/' + landmark_username
  
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri) # ?
  http = Net::HTTP.new(uri.host, uri.port)
  response = JSON.parse http.request(Net::HTTP::Get.new(uri.request_uri)).body
  
  newElements = {} # TODO remove null fields from response
  response.each { |key1, value1| 
    if LANDMARK_FIELDS.include?(key1)
      if value1.is_a?(Hash)
        value1.each { |key2, value2|
          newElements[key1 + '_' + key2] = value2
        }
      else
        newElements[key1 == 'id' ? 'fb_id' : key1] = value1
      end
    end
  }

  landmark = Landmark.create newElements
  
  ## fetch events
  
  oauth = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, CALLBACK_URL)
  graph = Koala::Facebook::API.new(oauth.get_app_access_token)
  
  response = graph.get_connections(landmark.username, 'events').raw_response['data']
  
  puts 'landmark = ' + landmark.username
  
  response.each { |event_|
    event_id = event_['id']
    newElements = {}
    
    koala_event = graph.get_object(event_id)
    koala_event.each { |key1, value1|
      if EVENT_FIELDS.include?(key1)
        if value1.is_a?(Hash)
          value1.each { |key2, value2|
            newElements[key1 + '_' + key2] = value2
          }
        else
          newElements[key1 == 'id' ? 'fb_id' : key1] = value1
        end
      end
    }
  
    landmark.events.create newElements
  }
}


