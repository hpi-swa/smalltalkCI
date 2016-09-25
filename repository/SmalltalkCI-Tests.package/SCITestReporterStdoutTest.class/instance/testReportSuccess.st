testing
testReportSuccess
	| runner reporter stream result expectedTests |
	runner := SCITestRunner runClasses: {SmalltalkCITest} named: 'MyRunnerName'.
	stream := WriteStream on: ''.
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	expectedTests := SmalltalkCITest methodDict keys select: [ :ea | ea startsWith: 'test' ].
	self assert: (result includesSubString: 'MyRunnerName').
	self assert: (result includesSubString: 'Executed ', expectedTests size, ' tests').
	self assert: (result endsWith: SCITestReporterStdout ansiReset)