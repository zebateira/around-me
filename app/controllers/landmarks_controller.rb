require 'json'

class LandmarksController < ApplicationController
  # GET /landmarks.json
  # GET /landmarks.xml
  def index
		@landmarks = 
			if params.include?(:radius)
				filter_by_radius
			else
				Landmark.all
			end
    
    respond_to do |format|
      format.json { render json: @landmarks.to_json(:only => Landmark::LANDMARK_INDEX_FIELDS) }
      format.xml { render xml: @landmarks.to_xml(:root => 'landmarks', :only => Landmark::LANDMARK_INDEX_FIELDS) }
    end
  end

  # GET /landmarks/1.json
  # GET /landmarks/1.xml
  def show
    @landmark = Landmark.find(params[:id])

		if params.include?('update')
			puts 'Forcing landmark update...'
			update params.include?('events')
		else
			update_thread = Thread.new do
				sleep(1)
				if FbConnection.new.is_outdated @landmark
					update false
				else
					puts 'Landmark ' + @landmark.username + ' up to date.'
				end
			end
		end
    
    respond_to do |format|
      format.json { render json: @landmark }
      format.xml { render xml: @landmark }
    end

  end

	def update(update_events)
		fb_connection = FbConnection.new
		
		puts 'Landmark ' + @landmark.username + ':' + @landmark.fb_id + ' outdated since ' + @landmark.updated_at.to_s + '. Starting update...'
		@landmark.update_attributes(fb_connection.fetch_landmark(@landmark.username))
		puts 'Landmark ' + @landmark.username + ':' + @landmark.fb_id + ' updated.'

		if update_events
			@landmark.events.each { |event|
				if fb_connection.is_event_outdated event
					EventsController.new.update event
				end
			}
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

  # POST /landmarks
  # POST /landmarks.json
  def create
		fb_connection = FbConnection.new

		puts 'fetching ' + params[:landmark][:username] + '...'
		@landmark = Landmark.create fb_connection.fetch_landmark params[:landmark][:username]
		puts 'landmark ' + @landmark.username + ' created.'

		fb_connection.set_events(@landmark)
    
    respond_to do |format|
      if @landmark.save
        format.html { redirect_to landmarks_url, notice: 'Landmark was successfully fetched.' }
        format.json { render json: @landmark, status: :created, location: @landmark }
      else
        format.html { render action: "new" }
        format.json { render json: @landmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /landmarks/1
  def destroy
    @landmark = Landmark.find(params[:id])
    @landmark.destroy

    respond_to format.html { redirect_to landmarks_url }
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

#### UTILS

=begin
	a = sin²(Δφ/2) + cos(φ1).cos(φ2).sin²(Δλ/2)
	c = 2.atan2(√a, √(1−a))
	dist = R * c

where	φ is latitude, λ is longitude, R is earth’s radius in km
=end
	def filter_by_radius
		deg2rad = Math::PI / 180.0
		earth_rad = 6371

		lat1 = params[:latitude].to_f
		lon1 = params[:longitude].to_f
		radius = params[:radius].to_f

		landmarks = []

		Landmark.all.each do |landmark|

			if !landmark.location_longitude
				next
			end

			lon2 = landmark.location_longitude
			lat2 = landmark.location_latitude

			dlon_rad = (lon2 - lon1) * deg2rad
			dlat_rad = (lat2 - lat1) * deg2rad
		 
			lat1_rad = lat1 * deg2rad
			lat2_rad = lat2 * deg2rad
		 
			a = Math.sin(dlat_rad/2.0) ** 2 + 
					Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2.0) ** 2
			c = 2.0 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

			dist = earth_rad * c
			
			if dist <= radius
				landmarks << landmark;
			end
		end

		landmarks
	end
  
end
