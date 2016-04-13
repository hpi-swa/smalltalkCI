executing
runTests
	self prepareCoverage.
	HDTestReport
		runClasses: self classesToTest
		named: self suiteName.
	self finishUpAfterCoverage