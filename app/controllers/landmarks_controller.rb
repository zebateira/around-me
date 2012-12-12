require 'json'

class LandmarksController < ApplicationController
  # GET /landmarks
  # GET /landmarks.json
  # GET /landmarks.xml
  def index
    @landmarks = Landmark.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @landmarks.to_json(:only => Landmark::LANDMARK_INDEX_FIELDS) }
      format.xml { render xml: @landmarks.to_xml(:root => 'landmarks', :only => Landmark::LANDMARK_INDEX_FIELDS) }
    end
  end

  # GET /landmarks/1
  # GET /landmarks/1.json
  # GET /landmarks/1.xml
  def show
    @landmark = Landmark.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @landmark }
      format.xml { render xml: @landmark }
    end
  end

  # GET /landmarks/new
  # GET /landmarks/new.json
  # GET /landmarks/new.xml
  def new
    @landmark = Landmark.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @landmark }
      format.xml { render xml: @landmark }
    end
  end

  # GET /landmarks/1/edit
  def edit
    @landmark = Landmark.find(params[:id])
  end

  # POST /landmarks
  # POST /landmarks.json
  def create
    redirect_to :controller => 'fb_connections', :action => 'fetch_landmark', :landmark => params[:landmark]
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

  # GET /landmarks/1/events
  # GET /landmarks/1/events.json
  # GET /landmarks/1/events.xml
  def events
    @landmark = Landmark.find(params[:id])

    respond_to do |format|
      format.json { render json: @landmark.events.to_json(:only => Event::EVENT_INDEX_FIELDS) }
      format.xml { render xml: @landmark.events.to_xml(:root => 'events', :only => Event::EVENT_INDEX_FIELDS) }
    end
  end
  
end
