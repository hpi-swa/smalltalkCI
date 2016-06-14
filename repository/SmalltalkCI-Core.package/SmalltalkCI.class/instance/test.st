executing
test
	self prepareForTesting.
	self isCoverageTestingEnabled
		ifTrue: [ self runTestsWithCoverage ]
		ifFalse: [ self runTests ]