executing
runTests
	^ self class testRunnerClass
		runClasses: self spec classesToTest
		named: self suiteName
		failOnZeroTests: self spec failOnZeroTests