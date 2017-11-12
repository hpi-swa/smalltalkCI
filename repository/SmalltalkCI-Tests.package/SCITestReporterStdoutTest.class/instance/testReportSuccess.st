testing
testReportSuccess
	| runner reporter stream result |
	runner := SmalltalkCI testRunnerClass runSpec: (
		SCIDummySpec
			named: 'Stdout-testReportSuccess'
			forClass: SCIPassingTests).
	stream := WriteStream on: (String new: 1000).
	reporter := SCITestReporterStdout report: runner on: stream.
	result := stream contents.
	self assert: self class successFixture matches: result