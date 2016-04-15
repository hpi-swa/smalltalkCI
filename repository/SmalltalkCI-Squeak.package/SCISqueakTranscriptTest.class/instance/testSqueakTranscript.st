testing
testSqueakTranscript
	self assert: (Transcript isKindOf: SCISqueakTranscript) equals: false.
	SCISqueakTranscript install.
	Transcript cr; show: 'foo'; crlf; showln: 'bar'.
	self assert: (Transcript isKindOf: SCISqueakTranscript) equals: true.
	self assert: SCISqueakTranscript allInstances size equals: 1.
	self assert: (SCISqueakTranscript allInstances first originalTranscript) equals: self transcript.
	self should: [ SCISqueakTranscript install ] raise: Error.
	SCISqueakTranscript uninstall.
	self assert: (Transcript isKindOf: SCISqueakTranscript) equals: false.
	self assert: Transcript equals: self transcript.