executing
runCI
	self prepareForCI.
	self loadProjects.
	self runTestsWithCoverage.
	self finishUpAfterCI