running-deprecated
runClasses: aCollectionOfClasses named: aSuiteName failOnZeroTests: failOnZeroTests
	| spec |
	SmalltalkCI deprecated: 'Use SCITestRunner>>runClasses:spec: instead'.
	spec := SmalltalkCISpec new.
	spec testing at: #failOnZeroTests put: failOnZeroTests.
	^ self runClasses: aCollectionOfClasses spec: spec