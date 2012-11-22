APP_ID = '360645504021378'
APP_SECRET = 'ae46706edcaef26358b5c4459b8ec91a'

# OAUTH
CALLBACK_URL = 'http://around-me.herokuapp.com/'

# API Calls
FB_GRAPH_API = 'http://graph.facebook.com'
FB_GRAPH_API_HTTPS = 'https://graph.facebook.com'

EVENT_FIELDS = ['id', 'description', 'end_time', 'is_date_only', 'name', 'owner', 'privacy', 'start_time', 'timezone', 'updated_time', 'about', 'affiliation', 'category', 'checkins', 'description', 'general_info', 'is_published', 'likes', 'link', 'location', 'network', 'name', 'phone', 'public_transit', 'starring', 'talking_about_count', 'username', 'website', 'were_here_count'] #, 'venue']

LANDMARK_FIELDS = ['id', 'about', 'affiliation', 'category', 'checkins', 'description', 'general_info', 'is_published', 'likes', 'link', 'location', 'network', 'name', 'phone', 'public_transit', 'starring', 'talking_about_count', 'username', 'website', 'were_here_count']

### LANDMARKS

# GET LANDMARK INDEX FIELDS
LANDMARK_INDEX_FIELDS = [ :id, :username, :name ]