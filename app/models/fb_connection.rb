class FbConnection < ActiveRecord::Base
  # attr_accessible :title, :body

	# OAUTH
	CALLBACK_URL = 'http://around-me.herokuapp.com/'
	APP_ID = '360645504021378'
	APP_SECRET = 'ae46706edcaef26358b5c4459b8ec91a'

	# API Calls
	FB_GRAPH_API = 'http://graph.facebook.com'
	FB_GRAPH_API_HTTPS = 'https://graph.facebook.com'

end
