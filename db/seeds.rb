['casadamusica', 'ColiseuPorto', 'fundacaoserralves', 'ClubRivoliPorto', 'contagiarte', 'HardClubPorto', 'FnacPortugal', 'RuaDireitaCaminha', 'SudoesteTMN', 'multiusosgondomar'].each { |landmark_username|
    
	fb_connection = FbConnection.new

	puts 'fetching ' + landmark_username + '...'
	landmark = Landmark.create fb_connection.fetch_landmark(:username => landmark_username)
	puts 'landmark ' + landmark.username + ' created.'

	fb_connection.set_events(landmark)
}
