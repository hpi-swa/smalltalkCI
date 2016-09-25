executing
runTests
	| runner |
	runner := SCITestRunner
		runClasses: self classesToTest
		named: self suiteName.
	self reportResults: runner.
	^ runner isSuccessful