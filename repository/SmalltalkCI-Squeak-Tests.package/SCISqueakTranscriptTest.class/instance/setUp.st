setup
setUp
	(Transcript isKindOf: SCISqueakTranscript)
		ifTrue: [ SCISqueakTranscript uninstall ]
		ifFalse: [ self originalTranscript: Transcript ]