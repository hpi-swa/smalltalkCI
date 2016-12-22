helpers
printDebug: aString 
	SmalltalkCI isDebug
		ifTrue: [SmalltalkCI printToStdout: aString]