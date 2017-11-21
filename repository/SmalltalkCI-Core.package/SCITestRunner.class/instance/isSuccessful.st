accessing
isSuccessful
	| zeroTestCheck deprecationWarningCheck |
	zeroTestCheck := spec failOnZeroTests
		ifTrue: [ self totalTests > 0 ]
		ifFalse: [ true ].
	deprecationWarningCheck := spec failOnSCIDeprecationWarnings
		ifTrue: [ SmalltalkCI deprecationWarnings isEmpty ]
		ifFalse: [ true ].
	^ zeroTestCheck and: [
		deprecationWarningCheck and: [
			(self erroredTests + self failedTests) = 0]]