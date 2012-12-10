APP_ID = '360645504021378'
APP_SECRET = 'ae46706edcaef26358b5c4459b8ec91a'

# OAUTH
CALLBACK_URL = 'http://around-me.herokuapp.com/'

# API Calls
FB_GRAPH_API = 'http://graph.facebook.com'
FB_GRAPH_API_HTTPS = 'https://graph.facebook.com'

### LANDMARKS

LANDMARK_FIELDS = ['id', 'about', 'affiliation', 'category', 'checkins', 'description', 'general_info', 'is_published', 'likes', 'link', 'location', 'network', 'name', 'phone', 'public_transit', 'starring', 'talking_about_count', 'username', 'website', 'were_here_count',
'cover']

LANDMARK_FIELDS_DEPTH1 = ['street', 'city', 'country', 'zip', 'latitude', 'longitude',
'cover_id', 'source']

# GET LANDMARK INDEX FIELDS
LANDMARK_INDEX_FIELDS = [:username, :name ]

### EVENTS

EVENT_FIELDS = ['id', 'description', 'end_time', 'is_date_only', 'name', 'owner', 'privacy', 'start_time', 'timezone', 'updated_time', 'about', 'affiliation', 'category', 'checkins', 'description', 'general_info', 'is_published', 'likes', 'link', 'location', 'network', 'name', 'phone', 'public_transit', 'starring', 'talking_about_count', 'username', 'website', 'were_here_count', 'picture'] #, 'venue']

EVENT_FIELDS_DEPTH = ['name', 'category', 'id', 'url']

# GET EVENT INDEX FIELDS
EVENT_INDEX_FIELDS = [:name, :id, :fb_id, :start_time]
