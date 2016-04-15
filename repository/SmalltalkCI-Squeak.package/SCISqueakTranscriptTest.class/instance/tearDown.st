setup
tearDown
	self originalTranscript isNil
		ifTrue: [ SCISqueakTranscript install ]
		ifFalse: [ Smalltalk at: #Transcript put: self originalTranscript ]