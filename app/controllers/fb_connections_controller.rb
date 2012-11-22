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
    
    #response = http_request(FB_GRAPH_API + '/' + @landmark.username)
    response = http_request(generate_request @landmark.username, LANDMARK_FIELDS)

    newElements = {} # TODO remove null fields from response
    response.each { |key, value| 
      if LANDMARK_FIELDS2.include?(key)
        newElements[key == 'id' ? 'fb_id' : key] = value
      end
    }

    @landmark                     = Landmark.create newElements
    @landmark.location_city       = response['location']['city']
    @landmark.location_country    = response['location']['country']
    @landmark.location_latitude   = response['location']['latitude']
    @landmark.location_longitude  = response['location']['longitude']
    @landmark.location_street     = response['location']['street']
    @landmark.location_zip        = response['location']['zip']
    
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
        if EVENT_FIELDS2.include?(key)
          newElements[key == 'id' ? 'fb_id' : key] = value
        end
      }
    
      event = @landmark.events.create newElements
      event.venue_id = koala_event['venue']['id']
      event.venue_latitude = koala_event['venue']['latitude']
      event.venue_longitude = koala_event['venue']['longitude']
      event.owner_id = koala_event['owner']['id']
      event.owner_category = koala_event['owner']['category']
      event.owner_name = koala_event['owner']['name']
  }
  end
  
  


  ##### Rails gen stuff

  # GET /fb_connections/1
  # GET /fb_connections/1.json
  def show
    @fb_connection = FbConnection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fb_connection }
    end
  end

  # GET /fb_connections/new
  # GET /fb_connections/new.json
  def new
    @fb_connection = FbConnection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fb_connection }
    end
  end

  # GET /fb_connections/1/edit
  def edit
    @fb_connection = FbConnection.find(params[:id])
  end

  # POST /fb_connections
  # POST /fb_connections.json
  def create
    @fb_connection = FbConnection.new(params[:fb_connection])

    respond_to do |format|
      if @fb_connection.save
        format.html { redirect_to @fb_connection, notice: 'Fb connection was successfully created.' }
        format.json { render json: @fb_connection, status: :created, location: @fb_connection }
      else
        format.html { render action: "new" }
        format.json { render json: @fb_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fb_connections/1
  # PUT /fb_connections/1.json
  def update
    @fb_connection = FbConnection.find(params[:id])

    respond_to do |format|
      if @fb_connection.update_attributes(params[:fb_connection])
        format.html { redirect_to @fb_connection, notice: 'Fb connection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fb_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fb_connections/1
  # DELETE /fb_connections/1.json
  def destroy
    @fb_connection = FbConnection.find(params[:id])
    @fb_connection.destroy

    respond_to do |format|
      format.html { redirect_to fb_connections_url }
      format.json { head :no_content }
    end
  end
end
