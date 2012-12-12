class Event < ActiveRecord::Base
  attr_accessible :description, :end_time, :fb_id, :is_date_only, 
                  :location, :name, :owner_category, 
                  :owner_id, :owner_name, :privacy, :start_time, 
                  :timezone, :updated_time, :picture_url
                  
  belongs_to :landmark

	EVENT_FIELDS = ['id', 'description', 'end_time', 'is_date_only', 'name', 'owner', 'privacy', 'start_time', 'timezone', 'updated_time', 'about', 'affiliation', 'category', 'checkins', 'description', 'general_info', 'is_published', 'likes', 'link', 'location', 'network', 'name', 'phone', 'public_transit', 'starring', 'talking_about_count', 'username', 'website', 'were_here_count', 'picture'] #, 'venue']

	EVENT_FIELDS_DEPTH = ['name', 'category', 'id', 'url']

	EVENT_INDEX_FIELDS = [:name, :id, :fb_id, :start_time]
end
