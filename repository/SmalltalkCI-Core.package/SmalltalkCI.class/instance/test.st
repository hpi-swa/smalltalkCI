executing
test
	self prepareForCI.
	self isCoverageTestingEnabled
		ifTrue: [ self runTestsWithCoverage ]
		ifFalse: [ self runTests ]