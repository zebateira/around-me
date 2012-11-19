class Event < ActiveRecord::Base
  attr_accessible :description, :end_time, :id, :is_date_only, 
                  :landmark_id, :location, :name, :owner_category, 
                  :owner_id, :owner_name, :privacy, :start_time, 
                  :timezone, :updated_time
                  
  belongs_to :landmark
end
