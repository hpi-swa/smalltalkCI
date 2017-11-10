executing
runTests
	^ self class testRunnerClass
		runSpec: self spec
		named: self suiteName