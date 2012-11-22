# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['casadamusica', 'ColiseuPorto', 'fundacaoserralves'].each { |landmark_username|
    
  url = FB_GRAPH_API + '/' + landmark_username
  
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri) # ?
  http = Net::HTTP.new(uri.host, uri.port)
  response = JSON.parse http.request(Net::HTTP::Get.new(uri.request_uri)).body
  
  deletedElements = {} # TODO remove null fields from response
  response.each { |key, value| 
    if LANDMARK_DEPTH1_FIELDS.include?(key)
      deletedElements[key] = response.delete(key)
    end
  }
  
  landmark                     = Landmark.create response
  landmark.location_city       = deletedElements['location']['city']
  landmark.location_country    = deletedElements['location']['country']
  landmark.location_latitude   = deletedElements['location']['latitude']
  landmark.location_longitude  = deletedElements['location']['longitude']
  landmark.location_street     = deletedElements['location']['street']
  landmark.location_zip        = deletedElements['location']['zip']
  
  
  oauth = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, CALLBACK_URL)
  graph = Koala::Facebook::API.new(oauth.get_app_access_token)
  
  response = graph.get_connections(landmark.username, 'events').raw_response['data']
  
  response.each { |event|
    landmark.events.create event
  }
  
}


