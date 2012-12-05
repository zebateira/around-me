require 'json'
require 'rack'

class RadiusController < ApplicationController
  
  def http_request(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri) # ?
    http = Net::HTTP.new(uri.host, uri.port)
    JSON.parse http.request(Net::HTTP::Get.new(uri.request_uri)).body
  end
  
  def extract_param()
    puts params[:latitude]
    puts params[:longitude]
    puts params[:raio]
    
    uri = URI.parse(url)
    env = Rack::MockRequest.env_for(uri)
    req = Rack::Request.new(env)
    param=req.params  # => {"param1"=>"value1", "param2"=>"value2", "param3"=>"value3"}

  haversine_distance(param)
  end
  

# PI = 3.1415926535

RAD_PER_DEG = 0.017453293  #  PI/180

# the great circle distance d will be in whatever units R is in

Rmiles = 3956           # radius of the great circle in miles
Rkm = 6371              # radius in kilometers...some algorithms use 6367
Rfeet = Rmiles * 5282   # radius in feet
Rmeters = Rkm * 1000    # radius in meters

def haversine_distance
    


@distances = Hash.new   # this is global because if computing lots of track point distances, it didn't make
                        # sense to new a Hash each time over potentially 100's of thousands of points
@landmarks = Landmark.all
=begin rdoc
  given two lat/lon points, compute the distance between the two points using the haversine formula
  the result will be a Hash of distances which are key'd by 'mi','km','ft', and 'm'
=end
    lat1=params[:latitude].to_f
    lon1=params[:longitude].to_f
    raio=params[:raio].to_f

@results = Hash.new

  @landmarks.each do |landmark|
  	  lon2=landmark.location_longitude
  	  lat2=landmark.location_latitude

		puts lon2

	  dlon = lon2 - lon1
	  dlat = lat2 - lat1
	 
	  dlon_rad = dlon * RAD_PER_DEG
	  dlat_rad = dlat * RAD_PER_DEG
	 
	  lat1_rad = lat1 * RAD_PER_DEG
	  lon1_rad = lon1 * RAD_PER_DEG
	 
	  lat2_rad = lat2 * RAD_PER_DEG
	  lon2_rad = lon2 * RAD_PER_DEG
	 
	  # puts "dlon: #{dlon}, dlon_rad: #{dlon_rad}, dlat: #{dlat}, dlat_rad: #{dlat_rad}"
	 
	  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
	  c = 2 * Math.asin( Math.sqrt(a))
	 
	  dMi = Rmiles * c          # delta between the two points in miles
	  dKm = Rkm * c             # delta in kilometers
	  dFeet = Rfeet * c         # delta in feet
	  dMeters = Rmeters * c     # delta in meters
	 
	  @distances["mi"] = dMi
	  @distances["km"] = dKm
	  @distances["ft"] = dFeet
	  @distances["m"] = dMeters
	  
  	  @results[landmark.username] = dKm;
  end

  respond_to do |format|
    format.json { render json: @results}
    format.xml { render xml: @results} 
  end
 end
end
