running-deprecated
runSuite: aTestSuite failOnZeroTests: failOnZeroTests
	| spec |
	spec := SmalltalkCISpec new.
	spec testing at: #failOnZeroTests put: failOnZeroTests.
	^ self runSuite: aTestSuite spec: spec