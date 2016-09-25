executing
runTestsWithCoverage
	self prepareCoverage.
	[ ^ self runTests ] ensure:
		[ self finishUpAfterCoverage ]