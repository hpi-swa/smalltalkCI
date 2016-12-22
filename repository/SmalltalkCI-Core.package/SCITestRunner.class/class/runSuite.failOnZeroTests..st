running
runSuite: aTestSuite failOnZeroTests: failOnZeroTests
	^ self new
		initializeOn: aTestSuite;
		failOnZeroTests: failOnZeroTests;
		run