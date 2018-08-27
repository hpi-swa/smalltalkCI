running
tearDown
	suite resources
		do: [ :each | each reset ].

	SmalltalkCI printToStdout: 'Finished running suite: ', result suiteName.
	
	(self spec failOnZeroTests and: [ result totalTests == 0 ])
		ifTrue: [ SCIError signal: 'No tests were executed.

If this is intended, use `#failOnZeroTests : false` in your SmalltalkCISpec.' ].
