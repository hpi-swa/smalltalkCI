running
runCase: aTestCase
	| result |
	result := SCITestRunnerResult new testCase: aTestCase; yourself.
	result testTime: (SmalltalkCI timeToRun: [ [ [ aTestCase runCase ]
			on: Halt , Error, TestFailure
			do: [ :err |
				result testError: err.
				aTestCase shouldPass ifTrue: [self serializeError: result testError of: aTestCase].
				result testStack: (self stackTraceString: err of: aTestCase) ] ] ]).
	(results at: aTestCase class ifAbsentPut: [ OrderedCollection new ])
		add: result