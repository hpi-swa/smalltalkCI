printing
printNotPassingResults
	| title |
	title := (result erroredTests + result failedTests) asString, ' tests did not pass:'.
	self printBanner: title color: SmalltalkCI ansiRed.
	result results keysAndValuesDo: [ :class :results | | notPassing |
		notPassing := results select: [ :result | result passed not ].
		notPassing ifNotEmpty: [
			self printTitle: class asString.
			notPassing do: [ :result | self printException: result ] ] ].
	SmalltalkCI isTravisBuild
		ifFalse: [ self printNotPassingSummary ]