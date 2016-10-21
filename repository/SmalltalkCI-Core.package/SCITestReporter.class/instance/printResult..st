printing
printResult: aResult
	aResult passed
		ifTrue: [ self printPass: aResult ]
		ifFalse: [ self printException: aResult ]