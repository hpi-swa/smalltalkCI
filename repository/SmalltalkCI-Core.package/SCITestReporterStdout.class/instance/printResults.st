printing
printResults
	(runner passingTests > 0 and: [ self hidePassingResults not ])
		ifTrue: [ self printPassingResults ].
	runner isSuccessful
		ifFalse: [ self printNotPassingResults ]