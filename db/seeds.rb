['casadamusica', 'ColiseuPorto', 'fundacaoserralves', 'contagiarte', 'HardClubPorto', 'FnacPortugal', 'multiusosgondomar'].each { |landmark_username|
    
	fb_connection = FbConnection.new

	puts 'fetching ' + landmark_username + '...'
	landmark = Landmark.create fb_connection.fetch_landmark(landmark_username)
	puts 'landmark ' + landmark_username + ' created.'

	fb_connection.set_events(landmark)
}
