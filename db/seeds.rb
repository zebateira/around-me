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
    if LANDMARK_FIELDS2.include?(key)
      newElements[key == 'id' ? 'fb_id' : key] = value
    end
  }

  landmark                     = Landmark.create newElements
  landmark.location_city       = response['location']['city']
  landmark.location_country    = response['location']['country']
  landmark.location_latitude   = response['location']['latitude']
  landmark.location_longitude  = response['location']['longitude']
  landmark.location_street     = response['location']['street']
  landmark.location_zip        = response['location']['zip']
  
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
      if EVENT_FIELDS2.include?(key)
        newElements[key == 'id' ? 'fb_id' : key] = value
      end
    }
  
    event = landmark.events.create newElements
    event.venue_id = koala_event['venue']['id']
    event.venue_latitude = koala_event['venue']['latitude']
    event.venue_longitude = koala_event['venue']['longitude']
    event.owner_id = koala_event['owner']['id']
    event.owner_category = koala_event['owner']['category']
    event.owner_name = koala_event['owner']['name']
  }
 
}


