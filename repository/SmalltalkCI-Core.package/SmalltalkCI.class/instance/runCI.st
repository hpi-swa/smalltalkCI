executing
runCI
	self prepareForCI.
	self loadProjects.
	self runTests.
	self finishUpAfterCI