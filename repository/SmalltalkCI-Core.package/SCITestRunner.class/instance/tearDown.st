running
tearDown
	suite resources
		do: [ :each | each reset ].

	SmalltalkCI printToStdout: 'Finished running suite: ', self suiteName.
	
	(self spec failOnZeroTests and: [ self totalTests == 0 ])
		ifTrue: [ SCIError signal: 'No tests were executed.

If this is intended, use `#failOnZeroTests : true` in your SmalltalkCISpec.' ].