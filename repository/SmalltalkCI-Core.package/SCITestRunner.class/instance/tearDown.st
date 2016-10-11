running
tearDown
	suite resources
		do: [ :each | each reset ].

	SmalltalkCI printToStdout: 'Finished running suite: ', self suiteName