['casadamusica', 'ColiseuPorto', 'fundacaoserralves', 'ClubRivoliPorto', 'contagiarte', 'HardClubPorto', 'FnacPortugal', 'RuaDireitaCaminha', 'SudoesteTMN', 'multiusosgondomar'].each { |landmark_username|
    
	FbConnection.new.fetch_landmark(:username => landmark_username)

}
