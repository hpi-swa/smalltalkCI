running
runCase: aTestCase
	| result |
	SmalltalkCI printDebug: aTestCase asString.
	result := SCITestRunnerResult new testCase: aTestCase; yourself.
	result time: (SmalltalkCI platformClass timeToRun: [
		[ [ self basicRunCase: aTestCase ]
			on: self class errorExceptions
			do: [ :err |
				result testError: err.
				(aTestCase shouldPass & (self spec testing at: #serializeError ifAbsent:[ true ]))
					ifTrue: [ self serializeError: result testError of: aTestCase ].
				result stack: (self stackTraceString: err of: aTestCase) ] ]
					on: self class skipExceptions
					do: [ :skip | result skipped: true ] ]).
	self printProgress: result.
	(results at: aTestCase class ifAbsentPut: [ OrderedCollection new ])
		add: result
		
	