require 'uri'
require 'net/http'
require 'net/https'

class FbConnectionsController < ApplicationController
  
  def http_request(url)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    JSON.parse http.request(Net::HTTP::Get.new(uri.request_uri)).body
  end
  
  def generate_request(username, fields)
    FbConnection::FB_GRAPH_API + '/' + username + '?' + fields.join(',')
  end

	def fetch_landmark
    @landmark = Landmark.new(params[:landmark])
    
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
  
  def fetch_events
    @oauth = Koala::Facebook::OAuth.new(FbConnection::APP_ID, FbConnection::APP_SECRET, FbConnection::CALLBACK_URL)
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
    
    response = @graph.get_connections(@landmark.username, 'events').raw_response['data']


    puts 'landmark = ' + @landmark.username + ' created'
    
		response.each { |event_|
		  event_id = event_['id']
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
		  
		  @landmark.events.create newElements
		}
  end
  
end
