executing
runTests
	^ self class testRunnerClass
		runClasses: self classesToTest
		named: self suiteName