testing
testSqueakTranscript
	| transcript |
	transcript := Transcript.
	self assert: (Transcript isKindOf: SCISqueakTranscript) equals: false.
	SCISqueakTranscript install.
	Transcript cr; show: '.'; crlf; showln: '.'.
	self assert: (Transcript isKindOf: SCISqueakTranscript) equals: true.
	self should: [ SCISqueakTranscript install ] raise: Error.
	SCISqueakTranscript uninstall.
	self assert: (Transcript isKindOf: SCISqueakTranscript) equals: false.
	self should: [ SCISqueakTranscript uninstall ] raise: Error.
	self assert: Transcript equals: transcript