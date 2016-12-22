accessing
isSuccessful
	| zeroTestCheck |
	zeroTestCheck := self failOnZeroTests
		ifTrue: [ self totalTests > 0 ]
		ifFalse: [ true ].
	^ zeroTestCheck and: [(self erroredTests + self failedTests) = 0]