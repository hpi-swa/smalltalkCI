executing
runCI
	self prepareForCI.
	self loadAllCompatibleSpecs.
	self isCoverageTestingEnabled
		ifTrue: [ self runTestsWithCoverage ]
		ifFalse: [ self runTests ].
	self finishUpAfterCI