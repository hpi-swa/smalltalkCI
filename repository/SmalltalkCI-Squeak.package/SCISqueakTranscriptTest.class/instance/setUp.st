setup
setUp
	self transcript: (Smalltalk at: #Transcript).
	(Transcript isKindOf: SCISqueakTranscript)
		ifTrue: [ Smalltalk at: #Transcript put: TranscriptStream new ]