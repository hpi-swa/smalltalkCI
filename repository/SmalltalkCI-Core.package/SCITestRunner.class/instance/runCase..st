running
runCase: aTestCase
	| result |
	result := SCITestRunnerResult new testCase: aTestCase; yourself.
	result testTime: [ [ [ aTestCase runCase ]
			on: Halt , Error, TestFailure
			do: [ :err |
				result testError: err.
				aTestCase shouldPass ifTrue: [self serializeError: result testError of: aTestCase].
				result testStack: (self stackTraceString: err of: aTestCase) ]]
					on: (Smalltalk at: #TestSkip ifAbsent: []) do: [ :err | "nothing to do..." ] ] timeToRun.
	(results at: aTestCase class ifAbsentPut: [ OrderedCollection new ])
		add: result.