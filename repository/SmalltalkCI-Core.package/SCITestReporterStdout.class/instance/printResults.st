printing
printResults
	(runner passingTests > 0 and: [ self spec hidePassingTests not ])
		ifTrue: [ self printPassingResults ].
	(runner isSuccessful not and: [ runner passingTests < runner totalTests])
		ifTrue: [ self printNotPassingResults ].
  self printDeprecationWarnings.
