# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['casadamusica', 'ColiseuPorto', 'fundacaoserralves'].each { |landmark|
    
  response = Landmark.http_request(FB_GRAPH_API + '/' + landmark.username)
  response = Landmark.http_request(Landmark.generate_request landmark.username, LANDMARK_FIELDS)
  
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
  
}


