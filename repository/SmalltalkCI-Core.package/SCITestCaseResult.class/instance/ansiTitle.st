accessing
ansiTitle
	| prefix |
	prefix := self passed
		ifTrue: [ self class checkMark, SmalltalkCI ansiReset ]
		ifFalse: [ self class ballot ].
	^ self color, ' ', prefix, ' ', self title, SmalltalkCI ansiReset