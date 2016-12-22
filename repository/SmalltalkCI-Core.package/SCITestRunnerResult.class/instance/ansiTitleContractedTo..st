accessing
ansiTitleContractedTo: anInteger
	| prefix |
	prefix := self passed
		ifTrue: [ self class checkMark, SmalltalkCI ansiReset ]
		ifFalse: [ self class ballot ].
	^ self color, ' ', prefix, ' ', (self title contractTo: anInteger), SmalltalkCI ansiReset