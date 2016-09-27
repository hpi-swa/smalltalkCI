testing
testReportSuccess
	| runner reporter stream result expectedTests |
	runner := SCITestRunner runClasses: {SmalltalkCITest} named: 'MyRunnerName'.
	stream := WriteStream on: ''.
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	expectedTests := SmalltalkCITest methodDict keys select: [ :ea | ea beginsWith: 'test' ].
	self assert: (result findString: 'MyRunnerName') > 0.
	self assert: (result findString: 'Executed ', expectedTests size asString, ' tests') > 0.
	self assert: (result endsWith: Character cr asString)