strings
checkMark
	SmalltalkCI platformSymbol = #gemstone
		ifTrue: [ ^ '-' ].
	^ (Character value: 10003) asString