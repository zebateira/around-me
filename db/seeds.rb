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
          field = key + '_'
          value.each { |key, value|
						if LANDMARK_FIELDS_DEPTH1.include?(key)
							newElements[field + (key == 'cover_id' ? 'id' : key)] = value
						end
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
  
  puts 'landmark ' + landmark.username + ' created'
  
  response.each { |event_|
    event_id = event_['id']
    newElements = {}
    
    koala_event = graph.get_object(event_id)
    koala_event.each { |key, value|
      if EVENT_FIELDS.include?(key)
        if value.is_a?(Hash)
          field = key + '_'
          value.each { |key, value|
						if value.is_a?(Hash)
							newElements[field + 'url'] = value['url'];
						else
							if EVENT_FIELDS_DEPTH.include?(key)			
								newElements[field + key] = value
							end
						end
          }
        else
          newElements[key == 'id' ? 'fb_id' : key] = value
        end
      end
    }


		uri = URI.parse(FB_GRAPH_API + '/' + event_id + '/picture?type=large&redirect=false')
		response = Net::HTTP.get_response(uri) # ?
		http = Net::HTTP.new(uri.host, uri.port)
		response = JSON.parse http.request(Net::HTTP::Get.new(uri.request_uri)).body

		newElements['picture_url'] = response['data']['url']
  
    landmark.events.create newElements
  }
}


