printing
printResults
	(runner passingTests > 0 and: [ self hidePassingTests not ])
		ifTrue: [ self printPassingResults ].
	runner isSuccessful
		ifFalse: [ self printNotPassingResults ]