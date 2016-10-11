printing
printResults
	runner passingTests > 0
		ifTrue: [ self printPassingResults ].
	runner isSuccessful
		ifFalse: [ self printNotPassingResults ]