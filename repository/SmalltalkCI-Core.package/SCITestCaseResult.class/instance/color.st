accessing
color
	self errored ifTrue: [ ^ SmalltalkCI ansiRed ].
	self failed ifTrue: [ ^ SmalltalkCI ansiYellow ].
	self passedUnexpectedly ifTrue: [ ^ SmalltalkCI ansiYellow ].
	^ SmalltalkCI ansiGreen