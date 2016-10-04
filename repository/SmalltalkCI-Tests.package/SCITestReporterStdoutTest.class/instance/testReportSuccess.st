testing
testReportSuccess
	| runner reporter stream result expectedTests expectedTestsString |
	runner := SmalltalkCI testRunnerClass runClasses: {SmalltalkCITest} named: 'MyRunnerName'.
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	expectedTests := (SmalltalkCI methodDictOf: SmalltalkCITest) keys select: [ :ea | ea beginsWith: 'test' ].
	expectedTestsString := 'Executed ', expectedTests size asString, ' tests'.
	self assert: (result findString: 'MyRunnerName') > 0 description: 'MyRunnerName not found in "', result ,'".' .
	self assert: (result findString: expectedTestsString) > 0 description: '"', expectedTestsString, '" not found in "', result ,'".' .
	self assert: (result endsWith: SmalltalkCI platformClass newLine) description: 'Test result does not end with newLine.'