running-deprecated
runSuite: aTestSuite failOnZeroTests: failOnZeroTests
	| spec |
	SmalltalkCI deprecated: 'Use SCITestRunner>>runSuite:spec: instead'.
	spec := SmalltalkCISpec new.
	spec testing at: #failOnZeroTests put: failOnZeroTests.
	^ self runSuite: aTestSuite spec: spec