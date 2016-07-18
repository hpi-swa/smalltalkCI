executing
runTestsWithCoverage
	| successful |
	self prepareCoverage.
	successful := self runTests.
	self finishUpAfterCoverage.
	^ successful