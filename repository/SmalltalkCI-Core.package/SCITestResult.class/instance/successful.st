accessing
successful
	| deprecationWarningCheck |
	deprecationWarningCheck := spec failOnSCIDeprecationWarnings
		ifTrue: [ SmalltalkCI deprecationWarnings isEmpty ]
		ifFalse: [ true ].
	^ deprecationWarningCheck and: [
			(self erroredTests + self failedTests) = 0]