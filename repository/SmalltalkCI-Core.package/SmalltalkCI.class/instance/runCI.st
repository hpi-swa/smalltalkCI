executing
runCI
	self prepareForCI.
	self loadProjects.
	self isCoverageTestingEnabled
		ifTrue: [ self runTestsWithCoverage ]
		ifFalse: [ self runTests ].
	self finishUpAfterCI