require 'json' 
require 'net/http'
require 'uri'

class LandmarksController < ApplicationController
  # GET /landmarks
  # GET /landmarks.json
  def index
    @landmarks = Landmark.all
    
    landmarks = @landmarks.to_json(:only => [ :id, :username, :name ])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: landmarks }
    end
  end

  # GET /landmarks/1
  # GET /landmarks/1.json
  def show
    @landmark = Landmark.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @landmark }
    end
  end

  # GET /landmarks/new
  # GET /landmarks/new.json
  def new
    @landmark = Landmark.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @landmark }
    end
  end

  # GET /landmarks/1/edit
  def edit
    @landmark = Landmark.find(params[:id])
  end

  # POST /landmarks
  # POST /landmarks.json
  def create
    @landmark = Landmark.new(params[:landmark])
    
    uri = URI.parse(FB_API + @landmark.username) # TODO: refactor

    response = Net::HTTP.get_response(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    @response = JSON.parse( response.body )
    
    deletedElements = {}
    @response.each { |key, value| 
      if LANDMARKS_DEPTH1_ELEMS.include?(key)
        deletedElements[key] = @response.delete(key)
      end
    }

    @landmark                     = Landmark.create @response
    @landmark.location_city       = deletedElements['location']['city']
    @landmark.location_country    = deletedElements['location']['country']
    @landmark.location_latitude   = deletedElements['location']['latitude']
    @landmark.location_longitude  = deletedElements['location']['longitude']
    @landmark.location_street     = deletedElements['location']['street']
    @landmark.location_zip        = deletedElements['location']['zip']
    
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

  # PUT /landmarks/1
  # PUT /landmarks/1.json
  def update
    @landmark = Landmark.find(params[:id])

    respond_to do |format|
      if @landmark.update_attributes(params[:landmark])
        format.html { redirect_to @landmark, notice: 'Landmark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @landmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /landmarks/1
  # DELETE /landmarks/1.json
  def destroy
    @landmark = Landmark.find(params[:id])
    @landmark.destroy

    respond_to do |format|
      format.html { redirect_to landmarks_url }
      format.json { head :no_content }
    end
  end
end
