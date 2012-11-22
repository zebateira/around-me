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
  response.each { |key, value| 
    if LANDMARK_FIELDS.include?(key)
      if value.is_a?(Hash)
        field = key
        value.each { |key, value|
          newElements[field + '_' + key] = value
        }
      else
        newElements[key == 'id' ? 'fb_id' : key] = value
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
    koala_event.each { |key, value|
      if EVENT_FIELDS.include?(key)
        if value.is_a?(Hash)
          field = key
          value.each { |key, value|
            newElements[field + '_' + key] = value
          }
        else
          newElements[key == 'id' ? 'fb_id' : key] = value
        end
      end
    }
  
    landmark.events.create newElements
  }
}


