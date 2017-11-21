as yet unclassified
deprecationWarning
	| senderMethod |
	senderMethod := (GsProcess _frameContentsAt: 3) first. "First sender is SmalltalkCI>>deprecated"
	^ senderMethod inClass asString, '>>', senderMethod selector asString