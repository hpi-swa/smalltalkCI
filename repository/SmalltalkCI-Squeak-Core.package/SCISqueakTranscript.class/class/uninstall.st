class initialization
uninstall
	self isInstalled
		ifTrue: [ Transcript uninstall ]
		ifFalse: [ self error: 'A SCISqueakTranscript is not installed.' ]