running
printProgress: aTestResult
	SmalltalkCI stdout nextPut: (aTestResult passed
		ifTrue: [ $. ]
		ifFalse: [ (aTestResult failed)
			ifTrue: [ $F ]
			ifFalse: [ $E ] ])
