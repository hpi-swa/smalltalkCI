accessing
ansiTitle
	| symbol |
	symbol := self passed
		ifTrue: [ self class checkMark ]
		ifFalse: [ self class ballot ].
	^ self color, ' ', symbol, ' ', self title, SmalltalkCI ansiReset