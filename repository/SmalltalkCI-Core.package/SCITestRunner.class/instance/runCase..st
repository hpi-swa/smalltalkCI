running
runCase: aTestCase
	| testCaseResult |
	SmalltalkCI printDebug: aTestCase asString.
	testCaseResult := SCITestCaseResult new testCase: aTestCase; yourself.
	testCaseResult time: (SmalltalkCI timeToRun: [
		[ [ self basicRunCase: aTestCase ]
			on: self class errorExceptions
			do: [ :err |
				testCaseResult testError: err.
				aTestCase shouldPass ifTrue: [ self serializeError: testCaseResult testError of: aTestCase].
				testCaseResult stack: (self stackTraceString: err of: aTestCase) ] ]
					on: self class skipExceptions
					do: [ :skip | testCaseResult skipped: true ] ]).
	self printProgress: testCaseResult.
	result add: testCaseResult for: aTestCase.
		
	