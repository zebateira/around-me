require 'uri'
require 'net/http'
require 'net/https'

class FbConnectionsController < ApplicationController
  
  def http_request(url)
    uri = URI.parse(url)

    response = Net::HTTP.get_response(uri) # ?
    http = Net::HTTP.new(uri.host, uri.port)
    JSON.parse http.request(Net::HTTP::Get.new(uri.request_uri)).body
  end
  
  #def https_request(url)
    #uri = URI.parse(url)
    
    #http = Net::HTTP.new(uri.host, uri.port)
    #http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    #http.request(Net::HTTP::Get.new(uri.request_uri))
  #end
  
  def generate_request(username, fields)
    FB_GRAPH_API + '/' + username + '?' + fields.join(',')
  end

  def fetch_landmark
    @landmark = Landmark.new(params[:landmark])
    
    response = http_request(generate_request @landmark.username, LANDMARK_FIELDS)

    newElements = {} # TODO remove null fields from response
    response.each { |key, value| 
      if LANDMARK_FIELDS.include?(key)
        if value.is_a?(Hash)
          field = key
          value.each { |key, value|
			if LANDMARK_FIELDS_DEPTH1.include?(key)			
	            newElements[field + '_' + key] = value
			end
          }
        else
          newElements[key == 'id' ? 'fb_id' : key] = value
        end
      end
    }

    @landmark = Landmark.create newElements
    
    fetch_events
    
    respond_to do |format|
      if @landmark.save
        format.html { redirect_to @landmark, notice: 'Landmark was successfully fetched.' }
        format.json { render json: @landmark, status: :created, location: @landmark }
      else
        format.html { render action: "new" }
        format.json { render json: @landmark.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def fetch_events # TODO owner and venue
    @oauth = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, CALLBACK_URL)
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
    
    response = @graph.get_connections(@landmark.username, 'events').raw_response['data']
    
    puts 'landmark = ' + @landmark.username
    
    response.each { |event_|
      event_id = event_['id']
      newElements = {}
      
      koala_event = @graph.get_object(event_id)
      koala_event.each { |key, value|
        if EVENT_FIELDS.include?(key)
          if value.is_a?(Hash)
            field = key
            value.each { |key, value|
			if EVENT_FIELDS_DEPTH1.include?(key)			
	            newElements[field + '_' + key] = value
			end
            }
          else
            newElements[key == 'id' ? 'fb_id' : key] = value
          end
        end
      }
    
      @landmark.events.create newElements
  }
  end
  
end
