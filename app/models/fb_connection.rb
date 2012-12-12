require 'uri'
require 'net/http'
require 'net/https'

class FbConnection
  # attr_accessible :title, :body

	# OAUTH
	CALLBACK_URL = 'http://around-me.herokuapp.com/'
	APP_ID = '360645504021378'
	APP_SECRET = 'ae46706edcaef26358b5c4459b8ec91a'

	# API Calls
	FB_GRAPH_API = 'http://graph.facebook.com'
	FB_GRAPH_API_HTTPS = 'https://graph.facebook.com'

  def http_request(url)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    JSON.parse http.request(Net::HTTP::Get.new(uri.request_uri)).body
  end
  
  def generate_request(username, fields)
    FbConnection::FB_GRAPH_API + '/' + username + '?' + fields.join(',')
  end	

	###### FETCH LANDMARK

	def fetch_landmark(landmark)
    @landmark = Landmark.new(landmark)

		puts 'fetching ' + @landmark.username + '...'
    
    response = http_request(generate_request @landmark.username, Landmark::LANDMARK_FIELDS)

    newElements = {}
    response.each { |key, value| 
      if Landmark::LANDMARK_FIELDS.include?(key)
        if value.is_a?(Hash)
          field = key + '_'
          value.each { |key, value|
						if Landmark::LANDMARK_FIELDS_DEPTH1.include?(key)
							newElements[field + (key == 'cover_id' ? 'id' : key)] = value
						end
          }
        else
          newElements[key == 'id' ? 'fb_id' : key] = value
        end
      end
    }

    @landmark = Landmark.create newElements

		puts 'landmark ' + @landmark.username + ' created.'

    fetch_events
    
    return @landmark
	end


	##### FETCH EVENTS

	 def fetch_events
    @oauth = Koala::Facebook::OAuth.new(FbConnection::APP_ID, FbConnection::APP_SECRET, FbConnection::CALLBACK_URL)
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
    
    response = @graph.get_connections(@landmark.username, 'events').raw_response['data']

		response.each { |event_|
		  event_id = event_['id']
		  newElements = {}
		  puts 'fetching event ' + event_id + ' for ' + @landmark.username + '...'

		  koala_event = @graph.get_object(event_id)
		  koala_event.each { |key, value|
		    if Event::EVENT_FIELDS.include?(key)
		      if value.is_a?(Hash)
		        field = key + '_'
		        value.each { |key, value|
							if Event::EVENT_FIELDS_DEPTH.include?(key)			
								newElements[field + key] = value
							end
		        }
		      else
		        newElements[key == 'id' ? 'fb_id' : key] = value
		      end
		    end
		  }

			newElements['picture_url'] = http_request(FbConnection::FB_GRAPH_API + '/' + event_id + '/picture?type=large&redirect=false')['data']['url']
		  
		  @landmark.events.create newElements

		  puts 'event ' + event_id + ' created.'
		}

		puts 'fetched ' + @landmark.events.length.to_s + ' events for ' + @landmark.username + '.'
  end

end
