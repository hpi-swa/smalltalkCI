running
setUp
	SmalltalkCI printToStdout: 'Running suite: ', suite name.

	"Initialize the test resources."
	suite resources do: [ :each |
		each isAvailable
			ifFalse: [ TestResult signalErrorWith: 'Resource ' , each name , ' could not be initialized' ] ]
