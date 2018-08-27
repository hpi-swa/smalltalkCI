printing
printResults
	(result passingTests > 0 and: [ self spec hidePassingTests not ])
		ifTrue: [ self printPassingResults ].
	(result successful not and: [ result passingTests < result totalTests])
		ifTrue: [ self printNotPassingResults ].
  self printDeprecationWarnings.
