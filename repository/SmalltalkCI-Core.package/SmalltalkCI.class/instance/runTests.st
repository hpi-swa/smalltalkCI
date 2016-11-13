executing
runTests
	^ self class testRunnerClass
		runClasses: self spec classesToTest
		named: self suiteName