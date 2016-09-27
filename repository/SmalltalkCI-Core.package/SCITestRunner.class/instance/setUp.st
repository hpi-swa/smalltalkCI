running
setUp
	Transcript cr; show: 'Running suite: ', suite name; cr.

	"Initialize the test resources."
	suite resources do: [ :each |
		each isAvailable
			ifFalse: [ TestResult signalErrorWith: 'Resource ' , each name , ' could not be initialized' ] ]
