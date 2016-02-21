class initialization
install
	self instancesExist
		ifFalse: [ SCISqueakTranscript new install ]
		ifTrue: [ self error: 'A SCISqueakTranscript already exists.' ]