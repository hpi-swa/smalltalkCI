executing
runTests
	self prepareCoverage.
	SCITestReport runClasses: self classesToTest named: self suiteName.
	self finishUpAfterCoverage