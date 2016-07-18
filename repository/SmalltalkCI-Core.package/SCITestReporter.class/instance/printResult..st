printing
printResult: aResult
	aResult passed ifTrue: [ self printPass: aResult ].
	aResult errored ifTrue: [ self printError: aResult ].
	aResult failed ifTrue: [ self printFailure: aResult ]