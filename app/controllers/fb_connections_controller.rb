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

    deletedElements = {} # TODO remove null fields from response
    response.each { |key, value| 
      if LANDMARK_DEPTH1_FIELDS.include?(key)
        deletedElements[key] = response.delete(key)
      end
    }

    @landmark                     = Landmark.create response
    @landmark.location_city       = deletedElements['location']['city']
    @landmark.location_country    = deletedElements['location']['country']
    @landmark.location_latitude   = deletedElements['location']['latitude']
    @landmark.location_longitude  = deletedElements['location']['longitude']
    @landmark.location_street     = deletedElements['location']['street']
    @landmark.location_zip        = deletedElements['location']['zip']
    
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
    
    response.each { |event|
      @landmark.events.create event
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
