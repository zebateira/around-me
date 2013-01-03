require 'uri'
require 'net/http'
require 'net/https'

class FbConnection
	# OAUTH
	CALLBACK_URL = 'http://around-me.herokuapp.com/'
	APP_ID = '360645504021378'
	APP_SECRET = 'ae46706edcaef26358b5c4459b8ec91a'

	# API Calls
	FB_GRAPH_API = 'http://graph.facebook.com'
	FB_GRAPH_API_HTTPS = 'https://graph.facebook.com'

	# maximum number of hours of outdated landmark
	HOURS_MULT = 60 * 60

	OUTDATED_LIMIT_LANDMARK = 1.0 * HOURS_MULT
	OUTDATED_LIMIT_EVENT = 1.0 * HOURS_MULT

	def initialize
    @oauth = Koala::Facebook::OAuth.new(FbConnection::APP_ID, FbConnection::APP_SECRET, FbConnection::CALLBACK_URL)
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
	end

######## FETCH LANDMARK

	def fetch_landmark(landmark_username)
    response = http_request(generate_request landmark_username, Landmark::LANDMARK_FIELDS)

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
    
    return newElements
	end


####### FETCH EVENTS

	 def set_events(landmark)
    
    response = @graph.get_connections(landmark.username, 'events').raw_response['data']

		response.each { |event_|
			event_id = event_['id']
	  	puts 'fetching event ' + event_id + ' for ' + landmark.username + '...'
			landmark.events.create fetch_event(event_id)
	  	puts 'event ' + event_id + ' created.'
		}

		puts 'fetched ' + landmark.events.length.to_s + ' events for ' + landmark.username + '.'
  end

	def fetch_event(event_id)
	  newElements = {}

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

		return newElements
	end

####### Utils

  def http_request(url)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    JSON.parse http.request(Net::HTTP::Get.new(uri.request_uri)).body
  end

  def generate_request(username, fields)
    FbConnection::FB_GRAPH_API + '/' + username + '?' + fields.join(',')
  end

	def is_outdated(object)
		(Time.now - object.updated_at) > OUTDATED_LIMIT_LANDMARK
	end

	def is_event_outdated(event)
		updated_time = @graph.get_object(event.fb_id, {'fields' => 'updated_time'})['updated_time']
		latest_updated_time = Time.parse(updated_time)

		return ((latest_updated_time > Time.parse(event.updated_time)) or ((Time.now - latest_updated_time) > OUTDATED_LIMIT_EVENT))
	end

end
