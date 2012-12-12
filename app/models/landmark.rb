class Landmark < ActiveRecord::Base
  attr_accessible :about, :category, :checkins, :description, 
                  :general_info, :fb_id, :is_published, :likes, 
                  :link, :location_city, :location_country, 
                  :location_latitude, :location_longitude, 
                  :location_street, :location_zip, :name, 
                  :phone, :public_transit, :talking_about_count, 
                  :username, :website, :were_here_count, :cover_id,
									:cover_source
  extend FriendlyId
  friendly_id :username, use: :slugged  
  has_many :events, :dependent => :destroy

	
	LANDMARK_FIELDS = ['id', 'about', 'affiliation', 'category', 'checkins', 'description', 'general_info', 'is_published', 'likes', 'link', 'location', 'network', 'name', 'phone', 'public_transit', 'starring', 'talking_about_count', 'username', 'website', 'were_here_count', 'cover']

	LANDMARK_FIELDS_DEPTH1 = ['street', 'city', 'country', 'zip', 'latitude', 'longitude', 'cover_id', 'source']

	LANDMARK_INDEX_FIELDS = [:username, :name ]
end
