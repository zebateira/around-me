class FbConnectionsController < ApplicationController
  
  def fetchLandmark
    @landmark = Landmark.new(params[:landmark])

    uri = URI.parse(FB_API + '/' + @landmark.username)

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
