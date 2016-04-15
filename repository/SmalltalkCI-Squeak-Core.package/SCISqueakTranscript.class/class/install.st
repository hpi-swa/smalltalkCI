class initialization
install
	self isInstalled
		ifFalse: [ SCISqueakTranscript new install ]
		ifTrue: [ self error: 'A SCISqueakTranscript already exists.' ]