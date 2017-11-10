testing
testReportSuccess
	| runner reporter stream result |
	runner := SmalltalkCI testRunnerClass
		runSpec: (SCIDummySpec forClass: SCIPassingTests) 
		named: 'Stdout-testReportSuccess'.
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	self assert: self class successFixture matches: result