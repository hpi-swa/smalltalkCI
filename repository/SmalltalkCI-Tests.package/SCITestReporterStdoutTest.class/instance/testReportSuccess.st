testing
testReportSuccess
	| runner reporter stream result expectedTests |
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCITest} named: 'MyRunnerName'.
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	expectedTests := (SmalltalkCI methodDictOf: SmalltalkCITest) keys select: [ :ea | ea beginsWith: 'test' ].
	self assert: (result findString: 'MyRunnerName') > 0.
	self assert: (result findString: 'Executed ', expectedTests size asString, ' tests') > 0.
	self assert: (result endsWith: SmalltalkCI platformClass newLine)